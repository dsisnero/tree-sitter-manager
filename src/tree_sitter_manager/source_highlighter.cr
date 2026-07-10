require "tree_sitter"
require "./highlight_configuration"
require "./query_manager"
require "./renderers"
require "./themes"
require "./grammar_loader"
require "./grammar_manager"

module TreeSitterManager
  # Lightweight capture data for testing without a real tree-sitter parser.
  record CaptureData, rule : String, start_byte : Int32, end_byte : Int32

  # Full-source highlighter: grammar → parse → query → captures → spans → render.
  #
  # Orchestrates the entire syntax highlighting pipeline:
  # 1. Load tree-sitter grammar for a language
  # 2. Parse source code
  # 3. Run highlight queries
  # 4. Map captures to styled spans
  # 5. Render spans to terminal/HTML
  class SourceHighlighter
    class GrammarNotFoundError < Exception
      getter language : String

      def initialize(@language : String)
        super("Grammar not found for '#{@language}'. Install it first with ensure_grammar.")
      end
    end

    getter language_name : String
    getter config : HighlightConfiguration
    property theme : ResolvedTheme?

    @base_dir : String

    def initialize(@language_name : String, @base_dir : String = "queries")
      @config = QueryManager.create_configuration(@language_name, @base_dir)
      @theme = nil
    end

    # Try to load the grammar without installing (returns nil if not found)
    def try_load : TreeSitter::Language?
      try_load_language
    end

    # Full pipeline: parse source, run queries, produce highlight spans.
    # Raises GrammarNotFoundError if the grammar is not installed.
    def highlight(source : String) : Array(Renderers::HighlightSpan)
      language = load_language
      parser = TreeSitter::Parser.new(language: language)
      tree = parser.parse(nil, source)
      return [] of Renderers::HighlightSpan unless tree

      run_query_on_tree(source, language, tree.root_node)
    end

    # Highlight using an already-parsed tree node (no re-parsing).
    # Ported from syntastica's `Processor#process_tree()` — useful for
    # incremental parsing in editors.
    #
    # The tree node must have been parsed with the same language.
    # Returns empty spans if the grammar is not installed.
    def highlight_tree(source : String, root_node : TreeSitter::Node) : Array(Renderers::HighlightSpan)
      language = try_load_language
      return [] of Renderers::HighlightSpan unless language

      run_query_on_tree(source, language, root_node)
    end

    # Convenience: accept a TreeSitter::Tree directly (uses root_node internally).
    def highlight_tree(source : String, tree : TreeSitter::Tree) : Array(Renderers::HighlightSpan)
      highlight_tree(source, tree.root_node)
    end

    # Highlight using a block that receives the language and returns a parsed tree.
    # The block should return a TreeSitter::Tree or nil.
    # Returns empty spans if the block returns nil.
    def highlight_tree(source : String, &block : TreeSitter::Language -> TreeSitter::Tree?) : Array(Renderers::HighlightSpan)
      language = try_load_language
      return [] of Renderers::HighlightSpan unless language

      tree = block.call(language)
      return [] of Renderers::HighlightSpan unless tree

      run_query_on_tree(source, language, tree.root_node)
    end

    private def run_query_on_tree(source : String, language : TreeSitter::Language, root_node : TreeSitter::Node) : Array(Renderers::HighlightSpan)
      query = config.build_query(language)
      cursor = TreeSitter::QueryCursor.new(query)
      captures = [] of TreeSitter::Capture

      cursor.exec(root_node) do |capture|
        captures << capture
      end

      tree_captures_to_spans(captures, source)
    end

    # Convert tree-sitter captures to highlight spans
    def tree_captures_to_spans(captures : Array(TreeSitter::Capture), source : String) : Array(Renderers::HighlightSpan)
      data = captures.map do |cap|
        CaptureData.new(
          rule: cap.rule,
          start_byte: cap.node.start_byte.to_i32,
          end_byte: cap.node.end_byte.to_i32,
        )
      end
      captures_to_spans(data, source)
    end

    # Convert capture data to non-overlapping, sorted highlight spans.
    #
    # Captures can overlap — when they do, later captures (by declaration order in the query)
    # take precedence. Spans are merged into contiguous regions.
    def captures_to_spans(captures : Array(CaptureData), source : String) : Array(Renderers::HighlightSpan)
      return [] of Renderers::HighlightSpan if captures.empty? || source.empty?

      # Sort by start position, then by end (shortest first for nesting)
      sorted = captures
        .select { |c| c.start_byte >= 0 && c.end_byte <= source.size && c.start_byte < c.end_byte }
        .sort_by { |c| {c.start_byte, -c.end_byte} }

      spans = [] of Renderers::HighlightSpan
      return spans if sorted.empty?

      # Resolve theme keys through the highlight configuration
      sorted.each do |cap|
        theme_key = resolve_capture_name(cap.rule)
        next if theme_key.nil? # "none" or unrecognized

        spans << Renderers::HighlightSpan.new(
          start: cap.start_byte,
          end_: cap.end_byte,
          theme_key: theme_key,
          style: Style.new,
        )
      end

      # Merge spans: when spans overlap, the later one wins on the overlapping region
      merged = merge_overlapping_spans(spans)
      merged
    end

    # Resolve a capture name (e.g. "function", "variable.builtin") to a theme key.
    # Returns nil for captures that should not be highlighted (e.g. starting with _).
    private def resolve_capture_name(name : String) : String?
      return nil if name.starts_with?('_')

      # Check if the capture name directly matches a theme key
      idx = config.highlight_index_for_capture(name)
      return nil if idx < 0

      # For exact "none" key, return nil (no highlight)
      theme_key = config.theme_keys[idx]?
      return nil if theme_key == "none"

      theme_key
    rescue
      name
    end

    # Render spans to ANSI terminal output
    def render_spans_to_terminal(source : String, spans : Array(Renderers::HighlightSpan)) : String
      Renderers::Terminal.render(source, spans, @theme)
    end

    # Render spans to HTML
    def render_spans_to_html(source : String, spans : Array(Renderers::HighlightSpan)) : String
      Renderers::Html.render(source, spans, @theme)
    end

    # Convenience: highlight and render to terminal in one call
    def highlight_to_terminal(source : String) : String
      spans = highlight(source)
      render_spans_to_terminal(source, spans)
    end

    # Convenience: highlight and render to HTML in one call
    def highlight_to_html(source : String) : String
      spans = highlight(source)
      render_spans_to_html(source, spans)
    end

    # Merge overlapping spans: split at overlap boundaries, later span wins
    private def merge_overlapping_spans(spans : Array(Renderers::HighlightSpan)) : Array(Renderers::HighlightSpan)
      return spans if spans.empty?

      # Collect all boundary points
      points = Set(Int32).new
      spans.each do |s|
        points << s.start
        points << s.end_
      end
      sorted_points = points.to_a.sort

      result = [] of Renderers::HighlightSpan
      (0...sorted_points.size - 1).each do |i|
        seg_start = sorted_points[i]
        seg_end = sorted_points[i + 1]

        # Find the last span that covers this segment (last = highest priority)
        covering = spans.select { |s| s.start <= seg_start && s.end_ >= seg_end }
        next if covering.empty?

        winner = covering.last
        result << Renderers::HighlightSpan.new(
          start: seg_start,
          end_: seg_end,
          style: winner.style,
          theme_key: winner.theme_key,
        )
      end

      # Merge adjacent segments with the same theme key
      merged = [] of Renderers::HighlightSpan
      result.each do |span|
        if merged.empty?
          merged << span
        elsif merged.last.theme_key == span.theme_key && merged.last.end_ == span.start
          last_span = merged.pop.not_nil!
          merged << Renderers::HighlightSpan.new(
            start: last_span.start,
            end_: span.end_,
            style: last_span.style,
            theme_key: last_span.theme_key,
          )
        else
          merged << span
        end
      end

      merged
    end

    private def load_language : TreeSitter::Language
      language = try_load_language
      return language if language

      STDERR.puts "Grammar '#{@language_name}' not found in cache. Installing..."
      result = GrammarManager.instance.install_grammar_sync(@language_name)

      language = try_load_language
      return language if language

      raise GrammarNotFoundError.new(result.error || "Grammar installed but not loadable")
    end

    private def try_load_language : TreeSitter::Language?
      loader_path = GrammarLoader.find_grammar_library(@language_name)
      return nil unless loader_path

      GrammarLoader.load_language(@language_name)
    rescue
      nil
    end
  end
end
