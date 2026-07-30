require "tree_sitter"
require "dir-walk"
require "./platform"
require "./xdg"
require "./directory_walker"

module TreeSitterManager
  # Platform-aware grammar shared library loading.
  # Searches registered directories with platform-appropriate extensions.
  module GrammarLoader
    extend self

    @@grammar_directories_mutex = Mutex.new
    @@grammar_directories = [] of String

    ENVIRONMENT_GRAMMAR_DIRECTORY        = "TREE_SITTER_MANAGER_GRAMMAR_DIR"
    LEGACY_ENVIRONMENT_GRAMMAR_DIRECTORY = "CHIASMUS_GRAMMAR_DIR"

    def register_grammar_directory(path : String) : Nil
      return unless Dir.exists?(path)

      @@grammar_directories_mutex.synchronize do
        @@grammar_directories << path unless @@grammar_directories.includes?(path)
      end
    end

    def grammar_directories : Array(String)
      @@grammar_directories_mutex.synchronize { @@grammar_directories.dup }
    end

    # Returns the explicit grammar root configured by the host application.
    # The Chiasmus variable remains a compatibility fallback only.
    def configured_grammar_directory : String?
      [ENV[ENVIRONMENT_GRAMMAR_DIRECTORY]?, ENV[LEGACY_ENVIRONMENT_GRAMMAR_DIRECTORY]?].each do |directory|
        return directory if directory && Dir.exists?(directory)
      end

      nil
    end

    def tree_sitter_available?(language : String) : Bool
      find_grammar_library(language) != nil
    end

    def find_grammar_library(language : String) : String?
      # Resolve C symbol name (e.g. csharp → c_sharp)
      symbol_name = LanguageRegistry.c_symbol_for(language)

      search_paths = grammar_search_paths
      ext = Platform.shared_library_extension
      standard_library_name = Platform.lib_name(symbol_name)

      search_paths.each do |dir|
        next unless Dir.exists?(dir)

        candidate_dirs = [
          File.join(dir, "tree-sitter-#{language}"),
          File.join(dir, "tree-sitter-#{language.gsub('_', "-")}"),
          dir,
        ]
        # Add C symbol-based directory
        candidate_dirs << File.join(dir, "tree-sitter-#{symbol_name}") if symbol_name != language

        candidate_dirs.each do |candidate_dir|
          next unless Dir.exists?(candidate_dir)

          # Standard name: libtree-sitter-{symbol}.{ext}
          lib_path = File.join(candidate_dir, standard_library_name)
          return lib_path if File.exists?(lib_path)

          # Tree-sitter CLI default: {lang}.{ext}
          alt_lang_path = File.join(candidate_dir, "#{language}.#{ext}")
          return alt_lang_path if File.exists?(alt_lang_path)

          # C symbol-based alt: {symbol}.{ext}
          alt_sym_path = File.join(candidate_dir, "#{symbol_name}.#{ext}")
          return alt_sym_path if File.exists?(alt_sym_path)

          # Some versions output: parser.{ext}
          parser_path = File.join(candidate_dir, "parser.#{ext}")
          return parser_path if File.exists?(parser_path)

          # Check subdirectories (e.g., tree-sitter-typescript/typescript/)
          DirectoryWalker.children(candidate_dir).each do |sub|
            sub_path = File.join(candidate_dir, sub)
            next unless Dir.exists?(sub_path)
            sub_lib = File.join(sub_path, standard_library_name)
            return sub_lib if File.exists?(sub_lib)
          end
        end

        # Sidecar packages and release archives may add layout directories.
        # Preserve search-root precedence by falling back before moving to the
        # next configured root.
        if library = find_library_recursively(dir, standard_library_name)
          return library
        end
      end

      nil
    end

    private def grammar_search_paths : Array(String)
      search_paths = [] of String

      if env_dir = configured_grammar_directory
        search_paths << env_dir
      end

      grammar_directories.each do |dir|
        search_paths << dir unless search_paths.includes?(dir)
      end

      cache_dir = XDG.grammar_cache_dir
      if Dir.exists?(cache_dir) && !search_paths.includes?(cache_dir)
        search_paths << cache_dir
      end

      project_vendor = File.expand_path("../../../grammars", __DIR__)
      if Dir.exists?(project_vendor) && !search_paths.includes?(project_vendor)
        search_paths << project_vendor
      end

      search_paths
    end

    def clear_registered_directories_for_test : Nil
      @@grammar_directories_mutex.synchronize { @@grammar_directories.clear }
    end

    def load_language(language : String) : TreeSitter::Language?
      lib_path = find_grammar_library(language)
      return nil unless lib_path

      handle = open_shared_library(lib_path)
      return nil if handle.null?

      # Try multiple symbol naming conventions using c_symbol_for
      resolved_symbol = LanguageRegistry.c_symbol_for(language)
      symbol_names = [
        "tree_sitter_#{resolved_symbol}",
        "tree_sitter_#{resolved_symbol.downcase}",
        "tree_sitter_#{language.gsub('-', '_')}",
        "tree_sitter_#{language}",
      ]

      ptr = nil
      symbol_names.each do |sym|
        ptr = lookup_shared_symbol(handle, sym)
        break if ptr
      end

      return nil unless ptr

      lang_ptr = Proc(LibTreeSitter::TSLanguage*).new(ptr, Pointer(Void).null).call
      TreeSitter::Language.new(language, lang_ptr)
    rescue ex
      nil
    end

    private def open_shared_library(path : String) : Void*
      {% if flag?(:win32) %}
        LibC.LoadLibraryExW(path.to_utf16, Pointer(Void).null, 0)
      {% else %}
        LibC.dlopen(path, LibC::RTLD_LAZY | LibC::RTLD_LOCAL)
      {% end %}
    end

    private def lookup_shared_symbol(handle : Void*, name : String) : Void*
      {% if flag?(:win32) %}
        LibC.GetProcAddress(handle, name).as(Void*)
      {% else %}
        LibC.dlsym(handle, name)
      {% end %}
    end

    private def find_library_recursively(root : String, library_name : String) : String?
      return nil unless Dir.exists?(root)

      matches = [] of String
      discovered = Channel(String).new
      completed = Channel(Nil).new(1)

      spawn do
        begin
          Dir::Walk.walk(nil, root) do |path, entry, error|
            next if error || !entry || !entry.file?
            discovered.send(path) if File.basename(path) == library_name
          end
        ensure
          discovered.close
          completed.send(nil)
        end
      end

      while path = discovered.receive?
        matches << path
      end
      completed.receive

      matches.sort!.first?
    end
  end
end
