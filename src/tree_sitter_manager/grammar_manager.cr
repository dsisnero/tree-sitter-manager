require "file_utils"
require "process"
require "json"
require "tree_sitter"
require "./platform"
require "./grammar_operations"
require "./language_loader"
require "./language_registry"
require "./grammar_metadata"
require "./embedded_grammars"
require "./xdg"
require "./directory_walker"
require "./cache_dir"
require "./timeout"
require "./result"

module TreeSitterManager
  # Single, non-blocking async GrammarManager using Crystal/Go-style concurrency
  # All operations are async by default, using fibers and channels
  class GrammarManager
    @@instance : GrammarManager?
    # Retains the requested path even if cache creation is denied by a sandbox.
    @@cache_dir : String?
    @@cache : CacheDir?
    @@initialized = false
    @@mutex = Mutex.new
    @state_mutex : Mutex
    @pending_ensures : Hash(String, Array(Channel(BoolResult)))
    @install_hook : Proc(String, BoolResult)?

    def initialize
      @state_mutex = Mutex.new
      @pending_ensures = {} of String => Array(Channel(BoolResult))
      @install_hook = nil
    end

    # Singleton instance
    def self.instance : GrammarManager
      @@mutex.synchronize do
        @@instance ||= new
      end
    end

    # Initialize with cache directory (async-safe)
    def self.init(cache_dir : String? = nil)
      return if @@initialized

      @@mutex.synchronize do
        return if @@initialized

        cache_path = cache_dir || default_cache_dir
        @@cache_dir = cache_path
        begin
          cache = CacheDir.new(cache_path)
          @@cache = cache
          migrate_legacy_cache_if_needed(cache)

          # A release can ship a verified native parser pack. Installing it
          # here keeps normal GrammarLoader lookup cache-first and offline.
          ParserPack.install_from_environment(cache.path)

          # Extract embedded grammars if available
          extract_embedded_grammars(cache)
        rescue File::Error
          # Sandboxed environments may not permit cache directory creation.
          # Keep the configured path and let later operations fail gracefully.
        end

        # Auto-create metadata for existing vendor grammars
        auto_create_vendor_metadata

        @@initialized = true
      end
    end

    # Check if a grammar is available (async, non-blocking)
    def grammar_available_async(language : String) : Channel(BoolResult)
      channel = Channel(BoolResult).new

      spawn do
        temp_dir : String? = nil
        begin
          # Check via tree-sitter repository (fast path)
          if TreeSitter::Repository.language_names.includes?(language)
            channel.send(BoolResult.success)
            next
          end

          # Check our cache
          if @@cache
            if grammar_path?(language)
              channel.send(BoolResult.success)
            else
              channel.send(BoolResult.new(value: false))
            end
          else
            channel.send(BoolResult.failure(
              "Cache directory not initialized",
              {"language" => language}
            ))
          end
        rescue ex
          channel.send(BoolResult.failure(
            "Error checking grammar availability: #{ex.message}",
            {"language" => language, "exception" => ex.class.to_s}
          ))
        end
      end

      channel
    end

    # Get grammar path (async, non-blocking)
    def get_grammar_path_async(language : String) : Channel(StringResult)
      channel = Channel(StringResult).new

      spawn do
        begin
          # Check tree-sitter repository first
          language_paths = LanguageLoader.repository_language_paths
          if path = language_paths[language]?
            so_path = path.join(Platform.lib_name(language))

            if File.exists?(so_path)
              channel.send(StringResult.success(so_path.to_s))
              next
            end
          end

          # Check cache
          if cache = @@cache
            if path = grammar_path?(language)
              channel.send(StringResult.success(path))
            else
              channel.send(StringResult.failure(
                "Grammar not found in cache",
                {"language" => language, "cache_dir" => cache.path}
              ))
            end
          else
            channel.send(StringResult.failure(
              "Cache directory not initialized",
              {"language" => language}
            ))
          end
        rescue ex
          channel.send(StringResult.failure(
            "Error getting grammar path: #{ex.message}",
            {"language" => language, "exception" => ex.class.to_s}
          ))
        end
      end

      channel
    end

    # Ensure a grammar is available (async, non-blocking)
    # This is the main entry point for grammar acquisition
    def ensure_grammar_async(language : String, timeout_ms : Int32 = 120_000) : Channel(BoolResult)
      self.class.init

      channel = Channel(BoolResult).new(1)
      spawn_resolution = false

      @state_mutex.synchronize do
        if waiters = @pending_ensures[language]?
          waiters << channel
        else
          @pending_ensures[language] = [channel]
          spawn_resolution = true
        end
      end

      if spawn_resolution
        spawn do
          notify_ensure_waiters(language, perform_ensure(language, timeout_ms))
        rescue ex
          notify_ensure_waiters(language, BoolResult.failure(
            "Error ensuring grammar: #{ex.message}",
            {"language" => language, "exception" => ex.class.to_s}
          ))
        end
      end

      channel
    end

    # Clear cache (async, non-blocking)
    def clear_cache_async : Channel(BoolResult)
      channel = Channel(BoolResult).new

      spawn do
        begin
          cache = @@cache
          unless cache && Dir.exists?(cache.path)
            channel.send(BoolResult.failure(
              "Cache directory does not exist",
              {"cache_dir" => @@cache_dir.to_s}
            ))
            next
          end

          cache.clear

          channel.send(BoolResult.success)
        rescue ex
          channel.send(BoolResult.failure(
            "Error clearing cache: #{ex.message}",
            {"exception" => ex.class.to_s}
          ))
        end
      end

      channel
    end

    # Get cache directory
    def cache_dir : String?
      @@cache.try(&.path) || @@cache_dir
    end

    # Sync wrapper for ensure_grammar_async — returns full result with error details
    def ensure_grammar_with_result(language : String, timeout_ms : Int32 = 120_000) : BoolResult
      channel = ensure_grammar_async(language, timeout_ms)
      result = Timeout.with_timeout_async(timeout_ms, channel)
      result || BoolResult.failure("Timeout waiting for grammar install", {"language" => language})
    end

    # Sync wrapper for ensure_grammar_async
    def ensure_grammar(language : String, timeout_ms : Int32 = 120_000) : Bool
      channel = ensure_grammar_async(language, timeout_ms)
      result = Timeout.with_timeout_async(timeout_ms, channel)
      result ? result.success? && result.value == true : false
    end

    # Sync wrapper for get_grammar_path_async
    def get_grammar_path(language : String) : String?
      channel = get_grammar_path_async(language)
      result = Timeout.with_timeout_async(5_000, channel)
      result && result.success? ? result.value : nil
    end

    # Sync wrapper for grammar_available_async
    def grammar_available?(language : String) : Bool
      channel = grammar_available_async(language)
      result = Timeout.with_timeout_async(5_000, channel)
      result ? result.success? && result.value == true : false
    end

    # Class method wrappers for convenience
    def self.ensure_grammar(language : String, timeout_ms : Int32 = 120_000) : Bool
      instance.ensure_grammar(language, timeout_ms)
    end

    def self.get_grammar_path(language : String) : String?
      instance.get_grammar_path(language)
    end

    def self.grammar_available?(language : String) : Bool
      instance.grammar_available?(language)
    end

    # Private methods

    private def self.default_cache_dir : String
      XDG.grammar_cache_dir
    end

    # Extract embedded grammars to cache directory
    private def self.extract_embedded_grammars(cache : CacheDir)
      # Only extract if we have embedded grammars
      return unless EmbeddedGrammars.embedded?("python") # Check if any grammar is embedded

      puts "[GrammarManager] Extracting embedded grammars to cache..." if ENV["CHIASMUS_DEBUG"]?

      # Try to extract all embedded grammars
      # If extraction fails, we'll fall back to downloading/building
      begin
        EmbeddedGrammars.extract_all_to_cache(cache)
      rescue ex
        # Silently fail - we'll download/build grammars as needed
        puts "[GrammarManager] Failed to extract embedded grammars: #{ex.message}" if ENV["CHIASMUS_DEBUG"]?
      end
    end

    private def self.migrate_legacy_cache_if_needed(cache : CacheDir)
      legacy_dir = legacy_cache_dir
      return unless legacy_dir
      cache.migrate_from_legacy(legacy_dir)
    rescue File::Error
      nil
    end

    private def self.legacy_cache_dir : String?
      {% if flag?(:darwin) %}
        File.join(Path.home.to_s, "Library", "Caches", "chiasmus", "grammars")
      {% else %}
        nil
      {% end %}
    end

    # Distribution grammars take precedence, then the managed cache.
    private def grammar_path?(language : String) : String?
      lib_name = Platform.lib_name(language)

      if binary_dir = get_binary_dir
        dist_grammar_dir = File.join(binary_dir, "grammars")
        distribution_path = File.join(dist_grammar_dir, lib_name)
        return distribution_path if File.exists?(distribution_path)
      end

      @@cache.try &.[language]?
    end

    # Get directory containing the binary
    private def get_binary_dir : String?
      # Try to get the directory of the running executable
      Process.executable_path.try { |path| File.dirname(path) }
    end

    # Ensure multiple dependencies concurrently (async)
    private def ensure_dependencies_async(dependencies : Array(String)) : Bool
      return true if dependencies.empty?

      channels = dependencies.map do |dep|
        ensure_grammar_async(dep, 60_000)
      end

      success = true
      channels.each do |channel|
        result = Timeout.with_timeout_async(60_000, channel)
        unless result && result.success? && result.value == true
          success = false
          break
        end
      end

      success
    end

    private def perform_ensure(language : String, timeout_ms : Int32) : BoolResult
      available_channel = grammar_available_async(language)
      available_result = Timeout.with_timeout_async(5_000, available_channel)

      unless available_result
        return BoolResult.failure(
          "Timeout checking if grammar is available",
          {"language" => language}
        )
      end

      if available_result.success? && available_result.value == true
        return BoolResult.success
      end

      deps = LanguageRegistry.dependencies(language)
      if !deps.empty?
        deps_success = ensure_dependencies_async(deps)
        unless deps_success
          return BoolResult.failure(
            "Failed to ensure dependencies",
            {"language" => language, "dependencies" => deps.join(", ")}
          )
        end
      end

      make_channel = make_grammar_available_async(language)
      make_result = Timeout.with_timeout_async(timeout_ms, make_channel)

      unless make_result
        return BoolResult.failure(
          "Timeout making grammar available",
          {"language" => language, "timeout_ms" => timeout_ms.to_s}
        )
      end

      make_result
    end

    private def notify_ensure_waiters(language : String, result : BoolResult) : Nil
      waiters = @state_mutex.synchronize { @pending_ensures.delete(language) } || [] of Channel(BoolResult)
      waiters.each(&.send(result))
    end

    # Make a grammar available (main async logic)
    private def make_grammar_available_async(language : String) : Channel(BoolResult)
      channel = Channel(BoolResult).new

      spawn do
        begin
          channel.send(install_grammar(language))
        rescue ex
          channel.send(BoolResult.failure(
            "Error making grammar available: #{ex.message}",
            {"language" => language, "exception" => ex.class.to_s}
          ))
        end
      end

      channel
    end

    private def install_grammar(language : String) : BoolResult
      if hook = @state_mutex.synchronize { @install_hook }
        return hook.call(language)
      end

      cache = @@cache
      return BoolResult.failure("Cache dir not initialized", {"language" => language}) unless cache

      Installer::Coordinator.new(cache, [
        Installer::GitCc.new,
        Installer::Npm.new,
        Installer::GitTreeSitter.new,
      ]).install(language)
    end

    # Direct synchronous install: clone + cc compile + cache in one shot.
    # Used by SourceHighlighter to ensure grammar availability before highlighting.
    def install_grammar_sync(language : String) : BoolResult
      ensure_grammar_with_result(language)
    end

    # Compile tree-sitter parser sources to a shared library using cc.
    # Like syntastica's parsers-git approach: direct cc, no tree-sitter CLI.
    # Returns {success, stderr_output} so callers can surface compiler diagnostics.
    def self.compile_sources(source_dir : String, language : String, output_path : String) : {Bool, String}
      ext = Platform.shared_library_extension
      src_dir = File.join(source_dir, "src")

      parser_c = File.join(src_dir, "parser.c")
      return {false, "parser.c not found in #{src_dir}"} unless File.exists?(parser_c)

      scanner_c = File.join(src_dir, "scanner.c")
      scanner_cc = File.join(src_dir, "scanner.cc")

      sources = [parser_c]
      sources << scanner_c if File.exists?(scanner_c)
      sources << scanner_cc if File.exists?(scanner_cc)

      args = ["-shared", "-fPIC", "-O2", "-I#{src_dir}", "-I/usr/local/include", "-I/usr/include"]
      {% if flag?(:darwin) %}
        args << "-dynamiclib"
        {% if flag?(:aarch64) || flag?(:arm64) %}
          args << "-arch" << "arm64"
        {% else %}
          args << "-arch" << "x86_64"
        {% end %}
      {% end %}
      args << "-o" << output_path
      args.concat(sources)

      success, err = try_compile("cc", args)
      unless success
        success, err = try_compile("gcc", args)
      end
      {success, err}
    end

    # Run a compiler and capture stderr
    private def self.try_compile(compiler : String, args : Array(String)) : {Bool, String}
      begin
        err_io = IO::Memory.new
        status = Process.run(compiler, args,
          output: Process::Redirect::Pipe,
          error: err_io,
        )
        {status.success?, err_io.to_s.strip}
      rescue ex
        {false, ex.message || "unknown error"}
      end
    end

    # Metadata-related methods

    # Auto-create metadata for existing vendor grammars
    private def self.auto_create_vendor_metadata
      vendor_grammars_dir = File.expand_path("../../grammars", __DIR__)
      return unless Dir.exists?(vendor_grammars_dir)

      created = GrammarMetadataStore.auto_create_for_existing(vendor_grammars_dir)
      if created && ENV["CHIASMUS_DEBUG"]?
        puts "[GrammarManager] Auto-created metadata for existing vendor grammars"
      end
    end

    # Get metadata for a grammar
    def get_grammar_metadata(language : String) : GrammarMetadata?
      # Check cache directory first
      if cache = @@cache
        language_dir = cache.language_dir(language)
        if Dir.exists?(language_dir)
          metadata = GrammarMetadataStore.load(language_dir)
          return metadata if metadata

          # Auto-create metadata if grammar exists but no metadata
          if grammar_directory?(language_dir)
            metadata = auto_create_metadata_for_cache(language, language_dir)
            return metadata if metadata
          end
        end
      end

      # Check vendor directory
      vendor_grammars_dir = File.expand_path("../../grammars", __DIR__)
      grammar_dir = find_grammar_dir_in_vendor(language, vendor_grammars_dir)
      if grammar_dir && Dir.exists?(grammar_dir)
        return GrammarMetadataStore.load(grammar_dir)
      end

      nil
    end

    # Check if a grammar has updates available (async)
    def update_check_async(language : String) : Channel(BoolResult)
      channel = Channel(BoolResult).new

      spawn do
        begin
          metadata = get_grammar_metadata(language)
          unless metadata
            channel.send(BoolResult.failure(
              "No metadata found for grammar",
              {"language" => language}
            ))
            next
          end

          case metadata.type
          when "git", "tree-sitter", "cc"
            channel.send(VersionChecker::Git.new.needs_update?(metadata.url, metadata.commit_hash))
          when "npm"
            channel.send(VersionChecker::Npm.new.needs_update?(metadata.package_name, metadata.version))
          when "local"
            # Local grammars don't have updates
            channel.send(BoolResult.new(value: false))
          else
            channel.send(BoolResult.failure(
              "Unknown grammar type",
              {"language" => language, "type" => metadata.type}
            ))
          end
        rescue ex
          channel.send(BoolResult.failure(
            "Error checking for updates: #{ex.message}",
            {"language" => language, "exception" => ex.class.to_s}
          ))
        end
      end

      channel
    end

    # Install grammar from local directory (async)
    def install_from_local_async(local_path : String, language : String? = nil) : Channel(BoolResult)
      channel = Channel(BoolResult).new

      spawn do
        begin
          unless Dir.exists?(local_path)
            channel.send(BoolResult.failure(
              "Local directory does not exist",
              {"path" => local_path}
            ))
            next
          end

          # Check if it looks like a tree-sitter grammar
          grammar_json = File.join(local_path, "grammar.json")
          src_dir = File.join(local_path, "src")

          unless File.exists?(grammar_json) || Dir.exists?(src_dir)
            channel.send(BoolResult.failure(
              "Directory does not appear to be a tree-sitter grammar",
              {"path" => local_path}
            ))
            next
          end

          # Infer language if not provided
          inferred_language = language
          unless inferred_language
            inferred_language = infer_language_from_path(local_path, grammar_json)
            unless inferred_language
              channel.send(BoolResult.failure(
                "Could not infer language from local grammar. Please specify with --language option.",
                {"path" => local_path}
              ))
              next
            end
          end

          if cache = @@cache
            channel.send(Installer::Coordinator.new(cache, [Installer::Local.new(local_path)]).install(inferred_language))
          else
            channel.send(BoolResult.failure(
              "Cache directory not initialized",
              {"path" => local_path}
            ))
          end
        rescue ex
          channel.send(BoolResult.failure(
            "Error installing local grammar: #{ex.message}",
            {"path" => local_path, "exception" => ex.class.to_s}
          ))
        end
      end

      channel
    end

    # Private helper methods

    private def find_grammar_dir_in_vendor(language : String, vendor_dir : String) : String?
      # Check for tree-sitter-language directory
      dir_name = "tree-sitter-#{language}"
      dir_path = File.join(vendor_dir, dir_name)
      return dir_path if Dir.exists?(dir_path)

      # Check for language directory
      dir_path = File.join(vendor_dir, language)
      return dir_path if Dir.exists?(dir_path)

      nil
    end

    # Check if a directory contains a grammar library
    private def grammar_directory?(dir_path : String) : Bool
      ext = Platform.shared_library_extension

      # Check for libtree-sitter-*.{so,dylib}
      DirectoryWalker.children(dir_path).any? do |filename|
        filename.starts_with?("libtree-sitter-") && filename.ends_with?(".#{ext}")
      end
    end

    # Auto-create metadata for a grammar in cache directory
    private def auto_create_metadata_for_cache(language : String, language_dir : String) : GrammarMetadata?
      # Try to infer metadata from directory name and contents
      metadata = GrammarMetadataStore.infer_metadata(language_dir)
      return nil unless metadata

      # Save the metadata
      if GrammarMetadataStore.save(language_dir, metadata)
        metadata
      else
        nil
      end
    end

    private def infer_language_from_path(local_path : String, grammar_json : String) : String?
      dir_name = File.basename(local_path)
      lang = GrammarMetadataStore.infer_language_from_package(dir_name)
      return lang if lang

      return nil unless File.exists?(grammar_json)

      begin
        grammar_data = JSON.parse(File.read(grammar_json))
        if name = grammar_data["name"]?.try(&.as_s?)
          GrammarMetadataStore.infer_language_from_package(name)
        end
      rescue
        nil
      end
    end
  end
end
