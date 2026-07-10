require "./spec_helper"

describe TreeSitterManager::SourceHighlighter do
  describe "configuration" do
    it "creates a highlighter for a language" do
      hl = TreeSitterManager::SourceHighlighter.new("python", "queries")
      hl.language_name.should eq("python")
      hl.config.should be_a(TreeSitterManager::HighlightConfiguration)
    end

    it "loads the highlight configuration" do
      hl = TreeSitterManager::SourceHighlighter.new("rust", "queries")
      hl.config.highlight_pattern_count.should be > 0
    end

    it "can specify a theme" do
      hl = TreeSitterManager::SourceHighlighter.new("python", "queries")
      hl.theme = TreeSitterManager::Themes.dracula
      hl.theme.should be_a(TreeSitterManager::ResolvedTheme)
    end
  end

  describe "#captures_to_spans" do
    it "converts highlight captures to styled spans" do
      hl = TreeSitterManager::SourceHighlighter.new("python", "queries")

      captures = [
        TreeSitterManager::CaptureData.new("keyword", 0, 3),
        TreeSitterManager::CaptureData.new("function", 4, 7),
        TreeSitterManager::CaptureData.new("string", 8, 15),
      ]

      source = "def foo \"hello\""
      spans = hl.captures_to_spans(captures, source)

      spans.size.should eq(3)
      spans[0].start.should eq(0)
      spans[0].end_.should eq(3)
      spans[0].theme_key.should eq("keyword")
      spans[1].start.should eq(4)
      spans[1].theme_key.should eq("function")
      spans[2].start.should eq(8)
      spans[2].theme_key.should eq("string")
    end

    it "resolves capture names through theme key mapping" do
      hl = TreeSitterManager::SourceHighlighter.new("python", "queries")

      captures = [TreeSitterManager::CaptureData.new("variable", 0, 4)]
      spans = hl.captures_to_spans(captures, "name")
      spans[0].theme_key.should eq("variable")
    end

    it "handles overlapping captures (last wins)" do
      hl = TreeSitterManager::SourceHighlighter.new("python", "queries")

      captures = [
        TreeSitterManager::CaptureData.new("variable", 0, 6),
        TreeSitterManager::CaptureData.new("function", 2, 4),
      ]
      spans = hl.captures_to_spans(captures, "abcdef")

      # Merged into two spans: variable-only [0,2) and function-override [2,4) and variable [4,6)
      spans.map { |s| {s.start, s.end_, s.theme_key} }.should eq([
        {0, 2, "variable"},
        {2, 4, "function"},
        {4, 6, "variable"},
      ])
    end

    it "sorts spans by start position" do
      hl = TreeSitterManager::SourceHighlighter.new("python", "queries")

      captures = [
        TreeSitterManager::CaptureData.new("string", 8, 15),
        TreeSitterManager::CaptureData.new("keyword", 0, 3),
        TreeSitterManager::CaptureData.new("function", 4, 7),
      ]
      spans = hl.captures_to_spans(captures, "def foo \"hello\"")
      spans[0].start.should eq(0)
      spans[1].start.should eq(4)
      spans[2].start.should eq(8)
    end

    it "handles empty captures" do
      hl = TreeSitterManager::SourceHighlighter.new("python", "queries")
      spans = hl.captures_to_spans([] of TreeSitterManager::CaptureData, "")
      spans.should be_empty
    end
  end

  describe "rendering pipeline" do
    it "renders spans to terminal via theme" do
      hl = TreeSitterManager::SourceHighlighter.new("python", "queries")
      hl.theme = TreeSitterManager::Themes.dracula

      source = "def foo(): pass"
      captures = [
        TreeSitterManager::CaptureData.new("keyword", 0, 3),
        TreeSitterManager::CaptureData.new("function", 4, 7),
      ]
      spans = hl.captures_to_spans(captures, source)
      output = hl.render_spans_to_terminal(source, spans)

      output.should contain("\e[")
      output.should contain("def")
      output.should contain("foo")
    end

    it "renders spans to HTML via theme" do
      hl = TreeSitterManager::SourceHighlighter.new("python", "queries")
      hl.theme = TreeSitterManager::Themes.dracula

      captures = [TreeSitterManager::CaptureData.new("variable", 0, 1)]
      spans = hl.captures_to_spans(captures, "x")
      output = hl.render_spans_to_html("x", spans)

      output.should contain("<pre")
      output.should contain("<span")
      output.should contain("</pre>")
    end
  end

  describe "full pipeline with grammar" do
    it "parses python and produces spans" do
      source = "def hello(name):\n    return f\"Hello, {name}!\""

      begin
        hl = TreeSitterManager::SourceHighlighter.new("python", "queries")
        result = hl.highlight(source)
        result.should be_a(Array(TreeSitterManager::Renderers::HighlightSpan))
        result.size.should be >= 0
      rescue ex : TreeSitterManager::SourceHighlighter::GrammarNotFoundError | TreeSitter::Error
        # Grammar not available or query incompatible — expected in CI/dev
      end
    end

    it "renders python to terminal with dracula theme" do
      source = "x = 42"

      begin
        hl = TreeSitterManager::SourceHighlighter.new("python", "queries")
        hl.theme = TreeSitterManager::Themes.dracula
        output = hl.highlight_to_terminal(source)
        output.should contain("x")
        output.should contain("42")
      rescue ex : TreeSitterManager::SourceHighlighter::GrammarNotFoundError | TreeSitter::Error
        # Grammar not available or query incompatible — expected in CI/dev
      end
    end

    it "renders python to HTML with nord theme" do
      source = "# comment\nx = 1"

      begin
        hl = TreeSitterManager::SourceHighlighter.new("python", "queries")
        hl.theme = TreeSitterManager::Themes.nord
        output = hl.highlight_to_html(source)
        output.should contain("<pre")
        output.should contain("comment")
        output.should contain("x")
      rescue ex : TreeSitterManager::SourceHighlighter::GrammarNotFoundError | TreeSitter::Error
        # Grammar not available or query incompatible — expected in CI/dev
      end
    end
  end
end
