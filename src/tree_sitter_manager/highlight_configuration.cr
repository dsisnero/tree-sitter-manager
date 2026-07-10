module TreeSitterManager
  # Configuration for syntax highlighting a language.
  #
  # Combines highlight, injection, and locals queries and maps capture
  # names to theme key indices. The combined query can be compiled into
  # a `TreeSitter::Query` given a `TreeSitter::Language`.
  class HighlightConfiguration
    getter language_name : String
    getter highlights_query : String
    getter injections_query : String
    getter locals_query : String

    @highlight_indices : Hash(String, Int32)
    @theme_keys : Array(String)
    @highlight_pattern_offset : Int32
    @injection_pattern_offset : Int32
    @local_pattern_offset : Int32
    @highlight_pattern_count : Int32
    @injection_pattern_count : Int32
    @local_pattern_count : Int32
    @has_injections : Bool

    def initialize(
      @language_name : String,
      @highlights_query : String,
      @injections_query : String,
      @locals_query : String,
      theme_keys : Array(String) = HighlightKeys::KEYS,
    )
      @theme_keys = theme_keys
      @highlight_indices = {} of String => Int32

      # Build combined query and track pattern offsets
      @highlight_pattern_offset = 0
      @highlight_pattern_count = count_patterns(@highlights_query)

      @injection_pattern_offset = @highlight_pattern_count
      @injection_pattern_count = count_patterns(@injections_query)

      @local_pattern_offset = @highlight_pattern_count + @injection_pattern_count
      @local_pattern_count = count_patterns(@locals_query)

      @has_injections = !@injections_query.strip.empty?

      # Build capture → highlight index mapping
      configure_highlight_indices
    end

    # The combined query source (highlights + injections + locals concatenated)
    def combined_query_source : String
      String.build do |io|
        io << @highlights_query
        io << '\n' unless @highlights_query.strip.empty? || @injections_query.strip.empty?
        io << @injections_query
        io << '\n' unless (@injections_query.strip.empty? && @highlights_query.strip.empty?) || @locals_query.strip.empty?
        io << @locals_query
      end
    end

    # Number of highlight patterns in the combined query
    def highlight_pattern_count : Int32
      @highlight_pattern_count
    end

    # Number of injection patterns in the combined query
    def injection_pattern_count : Int32
      @injection_pattern_count
    end

    # Number of locals patterns in the combined query
    def local_pattern_count : Int32
      @local_pattern_count
    end

    # Total number of patterns
    def pattern_count : Int32
      @highlight_pattern_count + @injection_pattern_count + @local_pattern_count
    end

    # Whether the configuration includes injection queries
    def has_injections? : Bool
      @has_injections
    end

    # Check if a pattern index is an injection pattern
    def injection_pattern?(index : Int32) : Bool
      index >= @injection_pattern_offset && index < @injection_pattern_offset + @injection_pattern_count
    end

    # Check if a pattern index is a locals pattern
    def local_pattern?(index : Int32) : Bool
      index >= @local_pattern_offset && index < @local_pattern_offset + @local_pattern_count
    end

    # Check if a pattern index is a highlight pattern
    def highlight_pattern?(index : Int32) : Bool
      index < @highlight_pattern_count
    end

    # Get the theme key index for a capture name.
    # Returns -1 if the capture name is not a recognized highlight category.
    def highlight_index_for_capture(capture_name : String) : Int32
      # Try exact match first
      if (idx = @highlight_indices[capture_name]?)
        return idx
      end

      # Try hierarchical fallback: strip dot-separated suffixes
      parts = capture_name.split('.')
      while parts.size > 0
        candidate = parts.join('.')
        if (idx = @highlight_indices[candidate]?)
          return idx
        end
        parts.pop
      end

      -1
    end

    # Get the theme key name for a capture index
    def theme_key_for_index(index : Int32) : String
      return "" if index < 0 || index >= @theme_keys.size
      @theme_keys[index]
    end

    # Get all capture names found in the highlight query
    def capture_names : Array(String)
      extract_capture_names(@highlights_query)
    end

    # The theme key array used for resolution
    def theme_keys : Array(String)
      @theme_keys
    end

    # Build a TreeSitter::Query from this configuration and a language
    def build_query(language : TreeSitter::Language) : TreeSitter::Query
      TreeSitter::Query.new(language, combined_query_source)
    end

    private def configure_highlight_indices : Nil
      # Build a reverse index: theme_key => index
      @theme_keys.each_with_index do |key, idx|
        @highlight_indices[key] = idx
      end
    end

    # Count the number of patterns in a query string by counting top-level S-expressions
    private def count_patterns(query : String) : Int32
      return 0 if query.strip.empty?

      result = Sexpr.from_slice_multi(query)
      return 0 unless result.success?

      count = 0
      result.unwrap.children.each do |node|
        case node
        when Sexpr::ListNode, Sexpr::GroupNode
          count += 1
        when Sexpr::StringNode, Sexpr::AtomNode
          # Standalone atoms/strings at root level are typically capture annotations
          # Count them only if followed by a list/group (handled by grouping)
          count += 1
        end
      end
      count
    rescue
      0
    end

    # Extract capture names (atoms starting with @) from a query string
    private def extract_capture_names(query : String) : Array(String)
      return [] of String if query.strip.empty?

      names = [] of String
      result = Sexpr.from_slice_multi(query)
      return names unless result.success?

      extract_captures_from_nodes(result.unwrap, names)
      names.uniq
    rescue
      [] of String
    end

    private def extract_captures_from_nodes(nodes : Sexpr::Nodes, names : Array(String)) : Nil
      nodes.children.each do |node|
        case node
        when Sexpr::AtomNode
          if node.value.starts_with?('@')
            names << node.value[1..]
          end
        when Sexpr::ListNode
          extract_captures_from_nodes(node.unwrap_list, names)
        when Sexpr::GroupNode
          extract_captures_from_nodes(node.unwrap_group, names)
        end
      end
    end
  end
end
