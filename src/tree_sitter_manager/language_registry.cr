require "mutex"
require "./language_registry_generated"

module TreeSitterManager
  # Centralized language registry following SOLID principles
  # Single Responsibility: Manage language metadata and configuration
  # Open/Closed: Can be extended without modifying existing code
  # Liskov Substitution: Provides consistent interface
  # Interface Segregation: Separate concerns for different use cases
  # Dependency Inversion: Depends on abstractions (interfaces) not concrete implementations
  #
  # Thread-safe for concurrent access in Crystal/Go-style concurrency environment
  module LanguageRegistry
    extend self

    # Re-export generated types
    alias Lang = LanguageRegistryGenerated::Lang
    LANGUAGE_NAMES = LanguageRegistryGenerated::LANGUAGE_NAMES

    # Language name aliases — common alternate names resolved to canonical form.
    # Ported from tree-sitter-language-pack registry.rs.
    ALIASES = {
      "shell"      => "bash",
      "bazel"      => "starlark",
      "gradle"     => "groovy",
      "ignorefile" => "gitignore",
      "lisp"       => "commonlisp",
      "makefile"   => "make",
    }

    # Resolve a possibly-aliased language name to its canonical form.
    def resolve_alias(name : String) : String
      ALIASES[name]? || name
    end

    # C symbol name overrides — some grammars export a C function name that
    # differs from the language name (e.g. csharp → tree_sitter_c_sharp).
    # Ported from tree-sitter-language-pack registry.rs.
    C_SYMBOL_OVERRIDES = {
      "csharp" => "c_sharp",
    }

    # Return the C function symbol name for a language.
    def c_symbol_for(name : String) : String
      C_SYMBOL_OVERRIDES[name]? || name.gsub('-', '_')
    end

    # Semantic language groups — curated sets for bulk operations.
    # Ported from tree-sitter-language-pack registry.rs group system.
    LANGUAGE_GROUPS = {
      "scripting"  => %w[python ruby javascript typescript lua perl php raku],
      "systems"    => %w[c cpp rust go zig],
      "web"        => %w[html css javascript typescript tsx],
      "data"       => %w[json yaml toml xml sql],
      "config"     => %w[dockerfile make cmake git-commit git-rebase],
      "shell"      => %w[bash fish],
      "jvm"        => %w[java kotlin scala clojure],
      "dotnet"     => %w[csharp],
      "mobile"     => %w[swift kotlin dart],
      "functional" => %w[haskell elixir erlang ocaml],
      "markup"     => %w[markdown html latex],
    }

    # Return language names belonging to a semantic group.
    def languages_in_group(group : String) : Array(String)
      LANGUAGE_GROUPS[group]? || [] of String
    end

    # Ambiguous extensions — some extensions map to multiple languages.
    # Ported from tree-sitter-language-pack definitions.rs `ambiguous` field.
    @@ambiguous_extensions = {} of String => Array(String)

    # Register a candidate language for an ambiguous extension (e.g. .m → objc, matlab).
    def register_ambiguous_extension(ext : String, language : String) : Nil
      @@mutex.synchronize do
        @@ambiguous_extensions[ext.downcase] ||= [] of String
        unless @@ambiguous_extensions[ext.downcase].includes?(language)
          @@ambiguous_extensions[ext.downcase] << language
        end
      end
    end

    # Return the list of candidate languages for an ambiguous extension.
    # Returns empty array if the extension is unambiguous or unknown.
    def ambiguous_for(ext : String) : Array(String)
      @@ambiguous_extensions[ext.downcase]? || [] of String
    end

    # Language metadata structure
    record LanguageInfo,
      name : String,
      package : String,
      module_export : String? = nil,
      wasm : Bool = false,
      wasm_file : String? = nil,
      preferred_method : Symbol = :git,
      dependencies : Array(String) = [] of String,
      extensions : Array(String) = [] of String,
      git_url : String = "",
      git_rev : String = "",
      ffi_func : String = "",
      parser_path : String = "",
      c_symbol : String? = nil,
      abi_version : UInt32? = nil

    # Thread-safe initialization using double-checked locking pattern
    private def ensure_initialized
      return if @@initialized

      @@mutex.synchronize do
        return if @@initialized

        registry = build_registry
        @@registry = registry
        @@extension_map = build_extension_map(registry)
        @@initialized = true
      end
    end

    private def registry : Hash(String, LanguageInfo)
      ensure_initialized
      @@registry || raise "Language registry not initialized"
    end

    private def extension_map : Hash(String, String)
      ensure_initialized
      @@extension_map || raise "Language extension map not initialized"
    end

    # Build comprehensive language registry from generated TOML data
    private def build_registry : Hash(String, LanguageInfo)
      registry = {} of String => LanguageInfo

      # Primary source: auto-generated from languages.toml (66 languages)
      LanguageRegistryGenerated::LANGUAGES.each do |entry|
        registry[entry["name"]] = LanguageInfo.new(
          name: entry["name"],
          package: "tree-sitter-#{entry["name"]}",
          extensions: entry["extensions"],
          git_url: entry["git_url"],
          git_rev: entry["git_rev"],
          ffi_func: entry["ffi_func"],
          c_symbol: entry["c_symbol"]?,
          abi_version: (v = entry["abi_version"]; v ? v.to_u32 : nil),
        )
      end

      # Supplementary manual overrides for languages with special needs
      # JavaScript/TypeScript family — multi-language package
      if ts = registry["typescript"]?
        registry["typescript"] = LanguageInfo.new(
          name: ts.name,
          package: ts.package,
          module_export: "typescript",
          preferred_method: :npm,
          dependencies: ["javascript"],
          extensions: ts.extensions,
          git_url: ts.git_url,
          git_rev: ts.git_rev,
          ffi_func: ts.ffi_func,
        )
      end

      if tsx = registry["tsx"]?
        registry["tsx"] = LanguageInfo.new(
          name: tsx.name,
          package: tsx.package,
          module_export: "tsx",
          preferred_method: :npm,
          dependencies: ["javascript"],
          extensions: tsx.extensions,
          git_url: tsx.git_url,
          git_rev: tsx.git_rev,
          ffi_func: tsx.ffi_func,
        )
      end

      # Clojure — WASM-based, different package
      registry["clojure"] = LanguageInfo.new(
        name: "clojure",
        package: "@yogthos/tree-sitter-clojure",
        wasm: true,
        wasm_file: "tree-sitter-clojure.wasm",
        preferred_method: :npm,
        extensions: [".clj", ".cljs", ".cljc", ".edn"],
        git_url: registry["clojure"]?.try(&.git_url) || "",
        git_rev: registry["clojure"]?.try(&.git_rev) || "",
        ffi_func: registry["clojure"]?.try(&.ffi_func) || "",
      )

      registry
    end

    # Get language info by Lang enum (type-safe, thread-safe)
    def get_language_info(lang : Lang) : LanguageInfo?
      get_language_info(lang.name)
    end

    # Get language info by name string (thread-safe, resolves aliases)
    def get_language_info(language : String) : LanguageInfo?
      registry[resolve_alias(language)]?
    end

    # Get all supported languages (thread-safe)
    def supported_languages : Array(String)
      registry.keys
    end

    # Get language for file extension (thread-safe).
    # For ambiguous extensions, returns the primary registered language.
    # Use LanguageDetection.resolve for content-based tiebreaking.
    def language_for_extension(ext : String) : String?
      extension_map[ext.downcase]?
    end

    # Get all supported extensions (thread-safe)
    def supported_extensions : Array(String)
      extension_map.keys
    end

    # Get preferred installation method for language (thread-safe)
    def preferred_method(language : String) : Symbol?
      info = get_language_info(language)
      info.try(&.preferred_method)
    end

    # Get dependencies for language (thread-safe)
    def dependencies(language : String) : Array(String)
      info = get_language_info(language)
      info.try(&.dependencies) || [] of String
    end

    # Check if language is WASM-based (thread-safe)
    def wasm_language?(language : String) : Bool
      info = get_language_info(language)
      info.try(&.wasm) || false
    end

    # Get package name for language (thread-safe)
    def package_name(language : String) : String?
      info = get_language_info(language)
      info.try(&.package)
    end

    # Get module export name for language (for multi-language packages) (thread-safe)
    def module_export(language : String) : String?
      info = get_language_info(language)
      info.try(&.module_export)
    end

    # Get WASM file name for language (thread-safe)
    def wasm_file(language : String) : String?
      info = get_language_info(language)
      info.try(&.wasm_file)
    end

    # Get extensions for language (thread-safe)
    def extensions_for_language(language : String) : Array(String)
      info = get_language_info(language)
      info.try(&.extensions) || [] of String
    end

    # Find language by package name (thread-safe)
    def language_for_package(package : String) : String?
      registry.each do |language, info|
        return language if info.package == package
      end
      nil
    end

    # Clear cache (useful for testing) - thread-safe
    def clear_cache
      @@mutex.synchronize do
        @@registry = nil
        @@extension_map = nil
        @@initialized = false
      end
    end

    # Register a custom language (thread-safe, for runtime extension)
    def register_language(info : LanguageInfo)
      @@mutex.synchronize do
        ensure_initialized
        updated_registry = registry.dup
        updated_extension_map = extension_map.dup

        updated_registry[info.name] = info
        info.extensions.each do |ext|
          updated_extension_map[ext.downcase] = info.name
        end

        @@registry = updated_registry
        @@extension_map = updated_extension_map
      end
    end

    # Unregister a language (thread-safe)
    def unregister_language(language : String)
      @@mutex.synchronize do
        ensure_initialized
        updated_registry = registry.dup
        updated_extension_map = extension_map.dup

        if info = updated_registry.delete(language)
          info.extensions.each do |ext|
            updated_extension_map.delete(ext.downcase)
          end
        end

        @@registry = updated_registry
        @@extension_map = updated_extension_map
      end
    end

    # Get git URL for a language from the registry (for grammar installation)
    # Resolves aliases before lookup.
    def git_url_for(language : String) : String?
      info = get_language_info(language)
      return nil unless info
      info.git_url.empty? ? nil : info.git_url
    end

    # Get FFI function name for a language (for dlsym loading)
    # Uses c_symbol_for to handle naming overrides.
    def ffi_func_for(language : String) : String?
      resolved = resolve_alias(language)
      info = get_language_info(resolved)
      return nil unless info
      info.ffi_func.empty? ? nil : info.ffi_func
    end

    private def build_extension_map(registry : Hash(String, LanguageInfo)) : Hash(String, String)
      map = {} of String => String

      # Primary source: extensions from languages.toml
      registry.each do |language, info|
        info.extensions.each do |ext|
          map[ext.downcase] = language
        end
      end

      map
    end

    # Thread-safe class variables
    @@mutex = Mutex.new
    @@initialized = false
    @@registry : Hash(String, LanguageInfo)? = nil
    @@extension_map : Hash(String, String)? = nil
  end
end
