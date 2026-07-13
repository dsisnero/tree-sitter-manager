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
require "./timeout"
require "./result"

module TreeSitterManager
  # Single, non-blocking async GrammarManager using Crystal/Go-style concurrency
  # All operations are async by default, using fibers and channels
  class GrammarManager
    @@instance : GrammarManager?
    @@cache_dir : String?
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

        @@cache_dir = cache_dir || default_cache_dir
        if cache_dir = @@cache_dir
          begin
            Dir.mkdir_p(cache_dir)
            migrate_legacy_cache_if_needed

            # Extract embedded grammars if available
            extract_embedded_grammars(cache_dir)
          rescue File::Error
            # Sandboxed environments may not permit cache directory creation.
            # Keep the configured path and let later operations fail gracefully.
          end
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
        begin
          # Check via tree-sitter repository (fast path)
          if TreeSitter::Repository.language_names.includes?(language)
            channel.send(BoolResult.success)
            next
          end

          # Check our cache
          if cache_dir = @@cache_dir
            available = grammar_cache_paths(language, cache_dir).any? do |so_path|
              exists_channel = GrammarOperations.file_exists_async(so_path)
              Timeout.with_timeout_async(5_000, exists_channel) == true
            end

            if available
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
            ext = Platform.shared_library_extension
            so_path = path.join("libtree-sitter-#{language}.#{ext}")

            exists_channel = GrammarOperations.file_exists_async(so_path.to_s)
            exists_result = Timeout.with_timeout_async(5_000, exists_channel)

            if exists_result == true
              channel.send(StringResult.success(so_path.to_s))
              next
            end
          end

          # Check cache
          if cache_dir = @@cache_dir
            found_path = grammar_cache_paths(language, cache_dir).find do |grammar_path|
              exists_channel = GrammarOperations.file_exists_async(grammar_path)
              Timeout.with_timeout_async(5_000, exists_channel) == true
            end

            if found_path
              channel.send(StringResult.success(found_path))
            else
              channel.send(StringResult.failure(
                "Grammar not found in cache",
                {"language" => language, "cache_dir" => cache_dir}
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

    # Copy a file atomically: cp to temp, then rename.
    # Prevents dlopen from seeing a partially written shared library.
    private def atomic_copy(src : String, dest : String) : Bool
      temp = "#{File.dirname(dest)}/.#{File.basename(dest)}.tmp.#{Process.pid}.#{Random.rand(1_000_000)}"
      begin
        FileUtils.cp(src, temp)
        File.chmod(temp, 0o755)
        File.rename(temp, dest)
        true
      rescue
        File.delete(temp) if File.exists?(temp)
        false
      end
    end

    # Clear cache (async, non-blocking)
    def clear_cache_async : Channel(BoolResult)
      channel = Channel(BoolResult).new

      spawn do
        begin
          cache_dir = @@cache_dir
          unless cache_dir && Dir.exists?(cache_dir)
            channel.send(BoolResult.failure(
              "Cache directory does not exist",
              {"cache_dir" => cache_dir.to_s}
            ))
            next
          end

          # Remove all .dylib/.so files
          ext = Platform.shared_library_extension
          Dir.glob(File.join(cache_dir, "**", "*.#{ext}")).each do |lib_file|
            File.delete(lib_file)
          end

          # Remove empty directories
          Dir.children(cache_dir).each do |dir|
            dir_path = File.join(cache_dir, dir)
            if Dir.exists?(dir_path) && Dir.empty?(dir_path)
              Dir.delete(dir_path)
            end
          end

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
      @@cache_dir
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

    def set_install_hook_for_test(&block : String -> BoolResult) : Nil
      @state_mutex.synchronize { @install_hook = block }
    end

    def clear_install_hook_for_test : Nil
      @state_mutex.synchronize { @install_hook = nil }
    end

    # Test helper to reset state
    def self.test_reset(cache_dir : String? = nil)
      @@mutex.synchronize do
        @@instance = nil
        @@cache_dir = cache_dir
        @@initialized = false
      end
    end

    # Private methods

    private def self.default_cache_dir : String
      XDG.grammar_cache_dir
    end

    # Extract embedded grammars to cache directory
    private def self.extract_embedded_grammars(cache_dir : String)
      # Only extract if we have embedded grammars
      return unless EmbeddedGrammars.embedded?("python") # Check if any grammar is embedded

      puts "[GrammarManager] Extracting embedded grammars to cache..." if ENV["CHIASMUS_DEBUG"]?

      # Try to extract all embedded grammars
      # If extraction fails, we'll fall back to downloading/building
      begin
        EmbeddedGrammars.extract_all_to_cache(cache_dir)
      rescue ex
        # Silently fail - we'll download/build grammars as needed
        puts "[GrammarManager] Failed to extract embedded grammars: #{ex.message}" if ENV["CHIASMUS_DEBUG"]?
      end
    end

    private def self.migrate_legacy_cache_if_needed
      legacy_dir = legacy_cache_dir
      return unless legacy_dir
      return unless Dir.exists?(legacy_dir)

      cache_dir = @@cache_dir
      return unless cache_dir
      return if same_path?(cache_dir, legacy_dir)

      Dir.children(legacy_dir).each do |entry|
        source = File.join(legacy_dir, entry)
        dest = File.join(cache_dir, entry)
        next if File.exists?(dest) || Dir.exists?(dest)

        FileUtils.cp_r(source, dest)
      end
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

    private def self.same_path?(left : String, right : String) : Bool
      File.expand_path(left) == File.expand_path(right)
    end

    private def grammar_cache_paths(language : String, cache_dir : String) : Array(String)
      ext = Platform.shared_library_extension
      lib_name = "libtree-sitter-#{language}.#{ext}"

      paths = [] of String

      # 1. Check in distribution grammars directory (relative to binary)
      if binary_dir = get_binary_dir
        dist_grammar_dir = File.join(binary_dir, "grammars")
        paths << File.join(dist_grammar_dir, lib_name)
      end

      # 2. Check in cache directory
      paths << File.join(cache_dir, language, lib_name)
      paths << File.join(cache_dir, "tree-sitter-#{language}", lib_name)

      paths
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

      preferred_method = LanguageRegistry.preferred_method(language)
      if preferred_method && install_with_method(language, preferred_method, 90_000)
        return BoolResult.success
      end

      return BoolResult.success if install_with_fallbacks(language)

      BoolResult.failure(
        "Failed to install grammar via any method",
        {"language" => language}
      )
    end

    private def install_with_fallbacks(language : String) : Bool
      install_with_method(language, :cc, 90_000) || install_with_method(language, :git, 60_000) || install_with_method(language, :npm, 60_000)
    end

    private def install_with_method(language : String, method : Symbol, timeout_ms : Int32) : Bool
      channel = case method
                when :cc  then install_via_cc_async(language)
                when :npm then install_via_npm_async(language)
                when :git then install_via_git_async(language)
                else           return false
                end

      successful_result?(Timeout.with_timeout_async(timeout_ms, channel))
    end

    private def successful_result?(result : BoolResult?) : Bool
      return false unless result

      result.success? && result.value == true
    end

    # Direct synchronous install: clone + cc compile + cache in one shot.
    # Used by SourceHighlighter to ensure grammar availability before highlighting.
    def install_grammar_sync(language : String) : BoolResult
      self.class.init

      package = LanguageRegistry.package_name(language)
      return BoolResult.failure("No package for #{language}") unless package

      repo = LanguageRegistry.git_url_for(language)
      return BoolResult.failure("No git URL for #{language}") unless repo

      cache = @@cache_dir
      return BoolResult.failure("Cache dir not initialized") unless cache

      ext = Platform.shared_library_extension
      sym = LanguageRegistry.c_symbol_for(language)
      lib_name = "#{Platform.library_prefix}tree-sitter-#{sym}.#{ext}"
      cache_dir = File.join(cache, language)
      cached = File.join(cache_dir, lib_name)

      return BoolResult.success if File.exists?(cached)

      Dir.mkdir_p(cache_dir)
      temp = File.join(Dir.tempdir, "tsm-install-#{language}-#{Random.rand(1_000_000)}")
      Dir.mkdir_p(temp)

      begin
        Dir.cd(temp) do
          clone_err = IO::Memory.new
          clone = retry_with_backoff("git clone") do
            Process.run("git", ["clone", "--depth", "1", repo, "."],
              output: Process::Redirect::Pipe, error: clone_err)
          end
          unless clone.success?
            return BoolResult.failure("git clone failed for #{repo}: #{clone_err.to_s.strip}", {"language" => language})
          end

          unless File.exists?(File.join(temp, "src", "parser.c"))
            subdir = LanguageRegistry.get_language_info(language).try(&.parser_path) || ""
            src_check = subdir.empty? ? File.join(temp, "src", "parser.c") : File.join(temp, subdir, "src", "parser.c")
            unless File.exists?(src_check)
              if system("which tree-sitter > /dev/null 2>&1")
                gen_dir = subdir.empty? ? temp : File.join(temp, subdir)
                gen_err = IO::Memory.new
                gen = Process.run("tree-sitter", ["generate"],
                  chdir: gen_dir,
                  output: Process::Redirect::Pipe, error: gen_err)
                unless gen.success?
                  return BoolResult.failure("tree-sitter generate failed: #{gen_err.to_s.strip}", {"language" => language})
                end
              end
            end
          end

          src_dir = temp
          subdir = LanguageRegistry.get_language_info(language).try(&.parser_path) || ""
          unless subdir.empty?
            src_dir = File.join(temp, subdir)
            return BoolResult.failure("Subdirectory not found: #{subdir}") unless Dir.exists?(src_dir)
          end

          output = File.join(temp, lib_name)
          compile_ok, compile_err = GrammarManager.compile_sources(src_dir, language, output)
          unless compile_ok
            msg = compile_err.empty? ? "cc compile failed" : "cc compile failed: #{compile_err}"
            return BoolResult.failure(msg, {"language" => language})
          end

          return BoolResult.failure("compiled lib not found") unless File.exists?(output)

          atomic_copy(output, cached)
        end
      rescue ex
        return BoolResult.failure("Install error: #{ex.message}", {"language" => language})
      ensure
        FileUtils.rm_rf(temp) if Dir.exists?(temp)
      end

      File.exists?(cached) ? BoolResult.success : BoolResult.failure("File not cached")
    end

    # Install via direct cc compilation (no tree-sitter CLI needed)
    private def install_via_cc_async(language : String) : Channel(BoolResult)
      channel = Channel(BoolResult).new

      spawn do
        begin
          package_name = LanguageRegistry.package_name(language)
          unless package_name
            channel.send(BoolResult.failure("No package name configured", {"language" => language}))
            next
          end

          cache_lib_dir = File.join(@@cache_dir.not_nil!, language)
          ext = Platform.shared_library_extension
          lib_name = "libtree-sitter-#{language}.#{ext}"
          cached_lib = File.join(cache_lib_dir, lib_name)

          repo_url = LanguageRegistry.git_url_for(language) || "https://github.com/tree-sitter/#{package_name}.git"

          # Git-specific pinning — use specific repo if known
          temp_dir = File.join(Dir.tempdir, "tsm-cc-#{Random.rand(1_000_000)}")
          Dir.mkdir_p(temp_dir)

          Dir.cd(temp_dir) do
            # Clone shallow (with retry + stderr capture)
            clone_err = IO::Memory.new
            clone_status = retry_with_backoff("git clone") do
              Process.run("git", ["clone", "--depth", "1", repo_url, "."],
                output: Process::Redirect::Pipe,
                error: clone_err,
              )
            end
            unless clone_status.success?
              channel.send(BoolResult.failure("git clone failed for #{repo_url}: #{clone_err.to_s.strip}", {"language" => language}))
              next
            end

            # Run tree-sitter generate if parser.c doesn't exist
            src_dir = File.join(temp_dir, "src")
            parser_c = File.join(src_dir, "parser.c")
            unless File.exists?(parser_c)
              STDERR.puts "  Generating parser (tree-sitter generate)..." if ENV["CHIASMUS_DEBUG"]?
              if system("which tree-sitter > /dev/null 2>&1")
                gen_out = IO::Memory.new
                gen_err = IO::Memory.new
                gen_status = Process.run("tree-sitter", ["generate"],
                  output: gen_out,
                  error: gen_err,
                )
                unless gen_status.success?
                  channel.send(BoolResult.failure("tree-sitter generate failed: #{gen_err.to_s.strip}", {"language" => language}))
                  next
                end
              end
            end

            # Compile with cc directly
            output_path = File.join(temp_dir, lib_name)
            Dir.mkdir_p(cache_lib_dir)
            STDERR.puts "  Compiling with cc..." if ENV["CHIASMUS_DEBUG"]?

            compile_ok, compile_err = GrammarManager.compile_sources(temp_dir, language, output_path)
            unless compile_ok
              msg = compile_err.empty? ? "cc compilation failed — check that cc is installed" : "cc compilation failed: #{compile_err}"
              channel.send(BoolResult.failure(msg, {"language" => language}))
              next
            end

            # Copy to cache atomically (prevents dlopen from seeing partial write)
            atomic_copy(output_path, cached_lib)

            # Save metadata
            commit_hash = nil
            commit_output = IO::Memory.new
            commit_result = Process.run("git", ["rev-parse", "HEAD"],
              output: commit_output,
              error: Process::Redirect::Pipe,
            )
            if commit_result.success?
              commit_hash = commit_output.to_s.strip
            end

            metadata = GrammarMetadata.new(
              url: repo_url,
              type: "cc",
              commit_hash: commit_hash,
              package_name: package_name,
              language: language,
              installed_at: Time.utc,
              last_updated: Time.utc,
            )
            GrammarMetadataStore.save(cache_lib_dir, metadata)

            channel.send(BoolResult.success)
          end
        rescue ex
          channel.send(BoolResult.failure("cc install error: #{ex.message}", {"language" => language}))
        end
      end

      channel
    end

    # Install via npm (async)
    private def install_via_npm_async(language : String) : Channel(BoolResult)
      channel = Channel(BoolResult).new

      spawn do
        begin
          package_name = LanguageRegistry.package_name(language)
          unless package_name
            channel.send(BoolResult.failure(
              "No package name configured for language",
              {"language" => language}
            ))
            next
          end

          # Create temp directory
          temp_dir = File.join(Dir.tempdir, "chiasmus-npm-#{Random.rand(1_000_000)}")
          Dir.mkdir_p(temp_dir)

          # Run npm install
          output = IO::Memory.new
          error = IO::Memory.new
          status = Process.run("npm", ["install", package_name],
            output: output,
            error: error
          )

          unless status.success?
            channel.send(BoolResult.failure(
              "npm install failed",
              {"language" => language, "package" => package_name, "error" => error.to_s}
            ))
            next
          end

          # Find and copy the grammar
          node_modules_path = File.join(temp_dir, "node_modules")
          if Dir.exists?(node_modules_path)
            # Look for the grammar file
            grammar_found = copy_grammar_from_node_modules(language, node_modules_path, package_name)

            if grammar_found
              # Try to get package version from package.json
              version = nil
              package_json_path = File.join(node_modules_path, package_name, "package.json")
              if File.exists?(package_json_path)
                begin
                  package_data = JSON.parse(File.read(package_json_path))
                  version = package_data["version"]?.try(&.as_s)
                rescue
                  # Ignore errors
                end
              end

              # Create metadata
              if cache_dir = @@cache_dir
                cache_lib_dir = File.join(cache_dir, language)
                metadata = GrammarMetadata.new(
                  url: "https://registry.npmjs.org/#{package_name}",
                  type: "npm",
                  version: version,
                  package_name: package_name,
                  language: language,
                  installed_at: Time.utc,
                  last_updated: Time.utc
                )

                GrammarMetadataStore.save(cache_lib_dir, metadata)
              end

              channel.send(BoolResult.success)
            else
              channel.send(BoolResult.failure(
                "Grammar not found in npm package",
                {"language" => language, "package" => package_name, "path" => node_modules_path}
              ))
            end
          else
            channel.send(BoolResult.failure(
              "node_modules not created",
              {"language" => language, "package" => package_name}
            ))
          end

          # Cleanup
          FileUtils.rm_rf(temp_dir) if Dir.exists?(temp_dir)
        rescue ex
          channel.send(BoolResult.failure(
            "Error installing via npm: #{ex.message}",
            {"language" => language, "exception" => ex.class.to_s}
          ))
        end
      end

      channel
    end

    # Install via git (async)
    private def install_via_git_async(language : String) : Channel(BoolResult)
      channel = Channel(BoolResult).new

      spawn do
        begin
          package_name = LanguageRegistry.package_name(language)
          unless package_name
            channel.send(BoolResult.failure(
              "No package name configured for language",
              {"language" => language}
            ))
            next
          end

          # Create temp directory
          temp_dir = File.join(Dir.tempdir, "chiasmus-git-#{Random.rand(1_000_000)}")
          Dir.mkdir_p(temp_dir)

          # Clone and build
          Dir.cd(temp_dir) do
            # Clone repository
            repo_url = LanguageRegistry.git_url_for(language) || "https://github.com/tree-sitter/#{package_name}.git"
            STDERR.puts "  Cloning #{repo_url}..." if ENV["CHIASMUS_DEBUG"]?
            output = IO::Memory.new
            error = IO::Memory.new
            status = Process.run("git", ["clone", "--depth", "1", repo_url, "."],
              output: output,
              error: error
            )

            unless status.success?
              channel.send(BoolResult.failure(
                "git clone failed",
                {"language" => language, "repo" => repo_url, "error" => error.to_s}
              ))
              next
            end

            # Build the grammar
            build_result = build_grammar_async(language, temp_dir)

            if build_result
              # Try to get commit hash
              commit_hash = nil
              commit_output = IO::Memory.new
              commit_error = IO::Memory.new
              commit_result = Process.run("git", ["rev-parse", "HEAD"],
                output: commit_output,
                error: commit_error
              )
              if commit_result.success?
                commit_hash = commit_output.to_s.strip
              end

              # Create metadata
              if cache_dir = @@cache_dir
                cache_lib_dir = File.join(cache_dir, language)
                metadata = GrammarMetadata.new(
                  url: repo_url,
                  type: "git",
                  commit_hash: commit_hash,
                  package_name: package_name,
                  language: language,
                  installed_at: Time.utc,
                  last_updated: Time.utc
                )

                GrammarMetadataStore.save(cache_lib_dir, metadata)
              end

              channel.send(BoolResult.success)
            else
              channel.send(BoolResult.failure(
                "Failed to build grammar",
                {"language" => language, "path" => temp_dir}
              ))
            end
          end

          # Cleanup
          FileUtils.rm_rf(temp_dir) if Dir.exists?(temp_dir)
        rescue ex
          channel.send(BoolResult.failure(
            "Error installing via git: #{ex.message}",
            {"language" => language, "exception" => ex.class.to_s}
          ))
        end
      end

      channel
    end

    # Build grammar (async)
    private def build_grammar_async(language : String, source_dir : String) : Bool
      Dir.cd(source_dir) do
        # Check if tree-sitter CLI is available
        unless system("which tree-sitter > /dev/null 2>&1")
          return false
        end

        # Generate parser
        generate_output = IO::Memory.new
        generate_error = IO::Memory.new
        generate_status = Process.run("tree-sitter", ["generate"],
          output: generate_output,
          error: generate_error
        )

        return false unless generate_status.success?

        # Build grammar
        build_output = IO::Memory.new
        build_error = IO::Memory.new
        build_status = Process.run("tree-sitter", ["build"],
          output: build_output,
          error: build_error
        )

        return false unless build_status.success?

        # Copy to cache
        ext = Platform.shared_library_extension
        source_lib = "#{language}.#{ext}"
        lib_name = "libtree-sitter-#{language}.#{ext}"

        # Rename if needed
        if File.exists?(source_lib) && !File.exists?(lib_name)
          File.rename(source_lib, lib_name)
        end

        # Copy to cache
        if cache_dir = @@cache_dir
          cache_lib_dir = File.join(cache_dir, language)
          Dir.mkdir_p(cache_lib_dir)

          dest_lib = File.join(cache_lib_dir, lib_name)
          if File.exists?(lib_name)
            atomic_copy(lib_name, dest_lib)
            return true
          end
        end

        false
      end
    rescue
      false
    end

    # Copy grammar from node_modules
    private def copy_grammar_from_node_modules(language : String, node_modules_path : String, package_name : String) : Bool
      # Look for the grammar file in various locations
      ext = Platform.shared_library_extension
      lib_name = "libtree-sitter-#{language}.#{ext}"

      possible_paths = [
        File.join(node_modules_path, package_name, lib_name),
        File.join(node_modules_path, package_name, "build", "Release", lib_name),
        File.join(node_modules_path, package_name, language + ".#{ext}"),
      ]

      source_path = possible_paths.find { |path| File.exists?(path) }
      return false unless source_path

      # Copy to cache
      if cache_dir = @@cache_dir
        cache_lib_dir = File.join(cache_dir, language)
        Dir.mkdir_p(cache_lib_dir)

        dest_lib = File.join(cache_lib_dir, lib_name)
        atomic_copy(source_path, dest_lib)
        return true
      end

      false
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

    # Retry a block with exponential backoff on transient failures.
    # The block should return a Process::Status or respond to .success?.
    # Retries up to 3 times with 1s, 2s, 4s delays between attempts.
    private def retry_with_backoff(label : String, &block : -> R) : R forall R
      delays = [1, 2, 4]
      delays.each do |delay|
        begin
          result = yield
          if result.responds_to?(:success?) && !result.success?
            STDERR.puts "  #{label} failed, retrying in #{delay}s..." if ENV["CHIASMUS_DEBUG"]?
            sleep(delay.seconds)
            next
          end
          return result
        rescue ex
          STDERR.puts "  #{label} raised (#{ex.message}), retrying in #{delay}s..." if ENV["CHIASMUS_DEBUG"]?
          sleep(delay.seconds)
        end
      end
      yield
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
      if cache_dir = @@cache_dir
        language_dir = File.join(cache_dir, language)
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
          when "git"
            result = check_git_updates_async(metadata)
            channel.send(result)
          when "npm"
            result = check_npm_updates_async(metadata)
            channel.send(result)
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

          # Build the grammar
          build_success = build_grammar_async(inferred_language, local_path)
          unless build_success
            channel.send(BoolResult.failure(
              "Failed to build local grammar",
              {"path" => local_path, "language" => inferred_language}
            ))
            next
          end

          # Copy to cache
          if cache_dir = @@cache_dir
            ext = Platform.shared_library_extension
            lib_name = "libtree-sitter-#{inferred_language}.#{ext}"
            source_lib = File.join(local_path, lib_name)

            unless File.exists?(source_lib)
              # Try alternative name
              source_lib = File.join(local_path, "#{inferred_language}.#{ext}")
            end

            if File.exists?(source_lib)
              cache_lib_dir = File.join(cache_dir, inferred_language)
              Dir.mkdir_p(cache_lib_dir)
              dest_lib = File.join(cache_lib_dir, lib_name)
              atomic_copy(source_lib, dest_lib)

              # Create metadata
              metadata = GrammarMetadata.new(
                url: local_path,
                type: "local",
                package_name: File.basename(local_path),
                language: inferred_language,
                installed_at: Time.utc,
                last_updated: Time.utc
              )

              GrammarMetadataStore.save(cache_lib_dir, metadata)

              channel.send(BoolResult.success)
            else
              channel.send(BoolResult.failure(
                "Built library not found",
                {"path" => local_path, "language" => inferred_language}
              ))
            end
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

    private def check_git_updates_async(metadata : GrammarMetadata) : BoolResult
      return BoolResult.failure("No URL for git grammar", {"language" => metadata.language}) if metadata.url.empty?

      begin
        # Create a temporary directory to clone into
        temp_dir = File.join(Dir.tempdir, "chiasmus-git-check-#{Random.rand(1_000_000)}")
        Dir.mkdir_p(temp_dir)

        begin
          # Clone the repository (shallow, single branch)
          clone_result = Process.run("git", ["clone", "--depth", "1", "--single-branch", metadata.url, temp_dir],
            output: Process::Redirect::Close, error: Process::Redirect::Close)

          unless clone_result.success?
            return BoolResult.failure("Failed to clone repository", {"language" => metadata.language, "url" => metadata.url})
          end

          # Get the latest commit hash
          commit_output = IO::Memory.new
          commit_result = Process.run("git", ["rev-parse", "HEAD"], chdir: temp_dir, output: commit_output)

          unless commit_result.success?
            return BoolResult.failure("Failed to get latest commit", {"language" => metadata.language})
          end

          latest_commit = commit_output.to_s.strip

          # Compare with local commit
          current_commit = metadata.commit_hash
          if current_commit && latest_commit != current_commit
            BoolResult.new(value: true, details: {
              "language"       => metadata.language,
              "current_commit" => current_commit,
              "latest_commit"  => latest_commit,
            })
          else
            BoolResult.new(value: false, details: {"language" => metadata.language})
          end
        ensure
          # Clean up temp directory
          FileUtils.rm_rf(temp_dir) if Dir.exists?(temp_dir)
        end
      rescue ex
        BoolResult.failure("Error checking git updates: #{ex.message}", {
          "language"  => metadata.language,
          "exception" => ex.class.to_s,
        })
      end
    end

    private def check_npm_updates_async(metadata : GrammarMetadata) : BoolResult
      return BoolResult.failure("No package name for npm grammar", {"language" => metadata.language}) if metadata.package_name.empty?

      begin
        # Check npm registry for latest version
        # Use npm view command
        npm_output = IO::Memory.new
        npm_view_result = Process.run("npm", ["view", metadata.package_name, "version"], output: npm_output)

        unless npm_view_result.success?
          # Try with --json flag
          npm_output = IO::Memory.new
          npm_view_result = Process.run("npm", ["view", metadata.package_name, "version", "--json"], output: npm_output)

          unless npm_view_result.success?
            return BoolResult.failure("Failed to check npm registry", {
              "language" => metadata.language,
              "package"  => metadata.package_name,
            })
          end
        end

        latest_version = npm_output.to_s.strip
        # Remove quotes if JSON response
        latest_version = latest_version.gsub(/^"|"$/, "")

        # Compare with local version
        current_version = metadata.version
        if current_version && latest_version != current_version
          BoolResult.new(value: true, details: {
            "language"        => metadata.language,
            "current_version" => current_version,
            "latest_version"  => latest_version,
          })
        else
          BoolResult.new(value: false, details: {"language" => metadata.language})
        end
      rescue ex
        BoolResult.failure("Error checking npm updates: #{ex.message}", {
          "language"  => metadata.language,
          "exception" => ex.class.to_s,
        })
      end
    end

    # Check if a directory contains a grammar library
    private def grammar_directory?(dir_path : String) : Bool
      ext = Platform.shared_library_extension

      # Check for libtree-sitter-*.{so,dylib}
      Dir.children(dir_path).any? do |filename|
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
