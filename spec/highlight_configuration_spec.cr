require "./spec_helper"

describe TreeSitterManager::HighlightConfiguration do
  describe ".new" do
    it "creates a config from query strings" do
      highlights = <<-SCM
        (identifier) @variable
        (string) @string
      SCM
      injections = <<-SCM
        (call_expression) @injection.content
        (#set! injection.language "sql")
      SCM
      locals = ""

      config = TreeSitterManager::HighlightConfiguration.new(
        language_name: "test",
        highlights_query: highlights,
        injections_query: injections,
        locals_query: locals,
        theme_keys: TreeSitterManager::HighlightKeys::KEYS,
      )

      config.should be_a(TreeSitterManager::HighlightConfiguration)
      config.language_name.should eq("test")
    end

    it "maps capture names to theme key indices" do
      highlights = %(((identifier) @variable))

      config = TreeSitterManager::HighlightConfiguration.new(
        language_name: "test",
        highlights_query: highlights,
        injections_query: "",
        locals_query: "",
        theme_keys: TreeSitterManager::HighlightKeys::KEYS,
      )

      # variable maps to the "variable" highlight key
      idx = config.highlight_index_for_capture("variable")
      idx.should be >= 0
    end

    it "resolves hierarchical capture names" do
      highlights = %(((identifier) @variable.builtin))

      config = TreeSitterManager::HighlightConfiguration.new(
        language_name: "test",
        highlights_query: highlights,
        injections_query: "",
        locals_query: "",
        theme_keys: TreeSitterManager::HighlightKeys::KEYS,
      )

      # variable.builtin should map to "variable.builtin" theme key
      idx = config.highlight_index_for_capture("variable.builtin")
      idx.should be >= 0
    end

    it "returns -1 for unrecognized capture names" do
      highlights = %(((identifier) @nonexistent_key))

      config = TreeSitterManager::HighlightConfiguration.new(
        language_name: "test",
        highlights_query: highlights,
        injections_query: "",
        locals_query: "",
        theme_keys: TreeSitterManager::HighlightKeys::KEYS,
      )

      idx = config.highlight_index_for_capture("nonexistent_key")
      idx.should eq(-1)
    end

    it "tracks which captures belong to highlight patterns" do
      highlights = %(((identifier) @variable)(string) @string)
      injections = %(((comment) @injection.content (#set! injection.language "comment")))

      config = TreeSitterManager::HighlightConfiguration.new(
        language_name: "test",
        highlights_query: highlights,
        injections_query: injections,
        locals_query: "",
        theme_keys: TreeSitterManager::HighlightKeys::KEYS,
      )

      config.highlight_pattern_count.should be > 0
    end

    it "detects injection captures" do
      injections = %(((code) @injection.content (#set! injection.language "python")))

      config = TreeSitterManager::HighlightConfiguration.new(
        language_name: "test",
        highlights_query: "",
        injections_query: injections,
        locals_query: "",
        theme_keys: TreeSitterManager::HighlightKeys::KEYS,
      )

      config.has_injections?.should be_true
    end

    it "provides the combined query source" do
      highlights = %(((identifier) @variable)
      )
      injections = "((code) @injection.content\n  (#set! injection.language \"python\"))"

      config = TreeSitterManager::HighlightConfiguration.new(
        language_name: "test",
        highlights_query: highlights,
        injections_query: injections,
        locals_query: "",
        theme_keys: TreeSitterManager::HighlightKeys::KEYS,
      )

      combined = config.combined_query_source
      combined.should contain("variable")
      combined.should contain("injection.content")
    end
  end
end
