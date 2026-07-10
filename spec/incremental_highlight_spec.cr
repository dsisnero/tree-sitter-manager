require "./spec_helper"

describe TreeSitterManager::SourceHighlighter do
  describe "#highlight_tree" do
    it "highlights using an existing parsed tree" do
      hl = TreeSitterManager::SourceHighlighter.new("rust")
      source = "fn main() {}\n"

      # Get language and parse manually
      language = hl.try_load.not_nil!
      parser = TreeSitter::Parser.new(language: language)
      tree = parser.parse(nil, source)
      tree.should_not be_nil

      # Highlight using the existing tree (no re-parse)
      spans = hl.highlight_tree(source, tree.not_nil!.root_node)
      spans.should be_a(Array(TreeSitterManager::Renderers::HighlightSpan))
      spans.should_not be_empty
    end

    it "produces same spans as highlight for same source" do
      hl = TreeSitterManager::SourceHighlighter.new("rust")
      source = "fn main() { let x = 1; }\n"

      spans1 = hl.highlight(source)
      spans2 = hl.highlight_tree(source) do |lang|
        parser = TreeSitter::Parser.new(language: lang)
        parser.parse(nil, source)
      end

      spans1.size.should eq(spans2.size)
    end

    it "returns empty array when tree block returns nil" do
      hl = TreeSitterManager::SourceHighlighter.new("rust")
      source = "fn main() {}\n"

      spans = hl.highlight_tree(source) { nil }
      spans.should be_empty
    end
  end
end
