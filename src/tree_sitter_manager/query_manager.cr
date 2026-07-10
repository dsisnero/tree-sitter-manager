module TreeSitterManager
  # Query kinds supported by tree-sitter.
  # Ported from tree-sitter-language-pack query_cache.rs QueryKind.
  enum QueryKind
    Highlights
    Folds
    Indents
    Injections
    Locals
    Tags
  end

  # Manages tree-sitter query files: loading, preprocessing, and caching.
  #
  # Reads `.scm` query files from the `queries/` directory, preprocesses
  # them (resolves `; inherits`, rewrites nvim predicates), and provides
  # `HighlightConfiguration` objects for syntax highlighting.
  module QueryManager
    extend self

    # Preprocessed query strings for a language
    record PreprocessedQueries,
      highlights : String = "",
      injections : String = "",
      locals : String = "",
      folds : String = "",
      indents : String = "",
      tags : String = ""

    @@cache = {} of String => PreprocessedQueries
    @@mutex = Mutex.new

    # Load and preprocess queries for a language
    def load_queries(language : String, base_dir : String = "queries") : PreprocessedQueries
      @@mutex.synchronize do
        return @@cache[language] if @@cache.has_key?(language)
      end

      nvim_like = nvim_like?(language)

      highlights = QueryPreprocessor.process_highlights_with_inherits(
        "", nvim_like, language, base_dir,
      )

      injections = QueryPreprocessor.process_injections_with_inherits(
        "", nvim_like, language, base_dir,
      )

      locals = QueryPreprocessor.process_locals_with_inherits(
        "", nvim_like, language, base_dir,
      )

      queries = PreprocessedQueries.new(
        highlights: highlights,
        injections: injections,
        locals: locals,
        folds: load_query_file("folds", language, base_dir, nvim_like),
        indents: load_query_file("indents", language, base_dir, nvim_like),
        tags: load_query_file("tags", language, base_dir, nvim_like),
      )

      @@mutex.synchronize do
        @@cache[language] = queries
      end

      queries
    end

    # Create a HighlightConfiguration from preprocessed queries
    def create_configuration(language : String, base_dir : String = "queries") : HighlightConfiguration
      queries = load_queries(language, base_dir)

      HighlightConfiguration.new(
        language_name: language,
        highlights_query: queries.highlights,
        injections_query: queries.injections,
        locals_query: queries.locals,
        theme_keys: HighlightKeys::KEYS,
      )
    end

    # Check if queries are cached for a language
    def cached?(language : String) : Bool
      @@mutex.synchronize { @@cache.has_key?(language) }
    end

    # Clear the query cache (useful for testing)
    def clear_cache : Nil
      @@mutex.synchronize { @@cache.clear }
    end

    # List languages that have query directories
    def available_languages(base_dir : String = "queries") : Array(String)
      return [] of String unless Dir.exists?(base_dir)

      Dir.children(base_dir).select do |entry|
        path = File.join(base_dir, entry)
        Dir.exists?(path) && File.exists?(File.join(path, "highlights.scm"))
      end
    end

    # Determine if a language uses nvim-like queries.
    # Most languages in languages.toml have nvim-like = true.
    private def nvim_like?(language : String) : Bool
      # Languages known to NOT use nvim-like queries
      non_nvim = %w[comment jsdoc]
      !non_nvim.includes?(language)
    end

    # Load a single query file by kind (folds, indents, tags, etc.)
    private def load_query_file(kind : String, language : String, base_dir : String, nvim_like : Bool) : String
      dir = File.join(base_dir, language)
      path = File.join(dir, "#{kind}.scm")
      return "" unless File.exists?(path)
      File.read(path)
    end
  end
end
