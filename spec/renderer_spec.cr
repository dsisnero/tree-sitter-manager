require "./spec_helper"

describe TreeSitterManager::Renderers::Terminal do
  describe ".render" do
    it "renders plain text with no styles" do
      source = "hello world"
      spans = [] of TreeSitterManager::Renderers::HighlightSpan

      output = TreeSitterManager::Renderers::Terminal.render(source, spans, nil)
      output.should eq("hello world")
    end

    it "renders styled text with ANSI codes" do
      source = "red text"
      style = TreeSitterManager::Style.new(
        color: TreeSitterManager::Color.new(255, 0, 0),
        bold: true,
      )
      spans = [
        TreeSitterManager::Renderers::HighlightSpan.new(0, 3, style),
        TreeSitterManager::Renderers::HighlightSpan.new(4, 8, style),
      ]

      output = TreeSitterManager::Renderers::Terminal.render(source, spans, nil)
      output.should contain("\e[")
      output.should contain("38;2;255;0;0")
      output.should contain("red")
      output.should contain("text")
    end

    it "resets ANSI codes between different styles" do
      source = "ab"
      red = TreeSitterManager::Style.new(color: TreeSitterManager::Color.new(255, 0, 0))
      blue = TreeSitterManager::Style.new(color: TreeSitterManager::Color.new(0, 0, 255))

      spans = [
        TreeSitterManager::Renderers::HighlightSpan.new(0, 1, red),
        TreeSitterManager::Renderers::HighlightSpan.new(1, 2, blue),
      ]

      output = TreeSitterManager::Renderers::Terminal.render(source, spans, nil)
      output.should contain("\e[0m")
    end

    it "renders background colors" do
      source = "bg"
      style = TreeSitterManager::Style.new(
        color: TreeSitterManager::Color.new(0, 0, 0),
        bg: TreeSitterManager::Color.new(255, 255, 0),
      )
      spans = [TreeSitterManager::Renderers::HighlightSpan.new(0, 2, style)]

      output = TreeSitterManager::Renderers::Terminal.render(source, spans, nil)
      output.should contain("48;2;255;255;0")
    end
  end

  describe "with theme" do
    it "resolves theme keys to styles" do
      source = "function call"
      theme = TreeSitterManager::Themes.dracula

      spans = [
        TreeSitterManager::Renderers::HighlightSpan.new(
          0, 8, TreeSitterManager::Style::NONE, "function"
        ),
      ]

      output = TreeSitterManager::Renderers::Terminal.render(source, spans, theme)
      # Dracula function color is #50fa7b => RGB(80, 250, 123)
      output.should contain("80;250;123")
    end
  end
end

describe TreeSitterManager::Renderers::Html do
  describe ".render" do
    it "renders plain text with no styles" do
      source = "hello world"
      spans = [] of TreeSitterManager::Renderers::HighlightSpan

      output = TreeSitterManager::Renderers::Html.render(source, spans, nil)
      output.should contain("<pre")
      output.should contain("hello world")
      output.should contain("</pre>")
    end

    it "renders styled text with CSS spans" do
      source = "red text"
      style = TreeSitterManager::Style.new(
        color: TreeSitterManager::Color.new(255, 0, 0),
        bold: true,
        italic: true,
      )
      spans = [TreeSitterManager::Renderers::HighlightSpan.new(0, 3, style)]

      output = TreeSitterManager::Renderers::Html.render(source, spans, nil)
      output.should contain("<span")
      output.should contain("color:#ff0000")
      output.should contain("font-weight:bold")
      output.should contain("font-style:italic")
      output.should contain("red")
    end

    it "escapes HTML entities" do
      source = "<div> & \"quoted\""
      span_style = TreeSitterManager::Style.new(color: TreeSitterManager::Color.new(0, 255, 0))
      spans = [TreeSitterManager::Renderers::HighlightSpan.new(0, source.size, span_style)]

      output = TreeSitterManager::Renderers::Html.render(source, spans, nil)
      output.should contain("&lt;div&gt;")
      output.should contain("&amp;")
      output.should contain("&quot;")
      output.should_not contain("<div>")
    end

    it "renders background colors in CSS" do
      source = "bg"
      style = TreeSitterManager::Style.new(
        color: TreeSitterManager::Color.new(255, 255, 255),
        bg: TreeSitterManager::Color.new(0, 0, 0),
      )
      spans = [TreeSitterManager::Renderers::HighlightSpan.new(0, 2, style)]

      output = TreeSitterManager::Renderers::Html.render(source, spans, nil)
      output.should contain("background-color:#000000")
    end

    it "renders underline and strikethrough" do
      source = "decorated"
      style = TreeSitterManager::Style.new(
        underline: true,
        strikethrough: true,
      )
      spans = [TreeSitterManager::Renderers::HighlightSpan.new(0, 9, style)]

      output = TreeSitterManager::Renderers::Html.render(source, spans, nil)
      output.should contain("text-decoration:underline line-through")
    end
  end

  describe "with theme" do
    it "resolves theme keys to styled CSS" do
      source = "keyword"
      theme = TreeSitterManager::Themes.dracula

      spans = [
        TreeSitterManager::Renderers::HighlightSpan.new(
          0, 7, TreeSitterManager::Style::NONE, "keyword"
        ),
      ]

      output = TreeSitterManager::Renderers::Html.render(source, spans, theme)
      # Dracula keyword is #ff79c6
      output.should contain("ff79c6")
    end
  end
end
