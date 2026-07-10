require "./spec_helper"

describe TreeSitterManager do
  it "has a working sexpr parser" do
    result = TreeSitterManager::Sexpr.from_slice("(hello world)")
    result.success?.should be_true
  end

  it "has highlight keys defined" do
    TreeSitterManager::HighlightKeys::KEYS.size.should be > 80
  end

  it "can parse lua patterns" do
    result = TreeSitterManager::LuaPattern.parse("%w")
    result.size.should eq(1)
  end

  it "can preprocess queries" do
    result = TreeSitterManager::QueryPreprocessor.process("(pattern) @capture", strip_comment: "crates.io")
    result.should_not be_empty
  end

  it "can create highlight configurations" do
    config = TreeSitterManager::HighlightConfiguration.new(
      language_name: "test",
      highlights_query: "((id) @variable)",
      injections_query: "",
      locals_query: "",
      theme_keys: TreeSitterManager::HighlightKeys::KEYS,
    )
    config.language_name.should eq("test")
  end

  it "can load queries for python" do
    queries = TreeSitterManager::QueryManager.load_queries("python", "queries")
    queries.highlights.should_not be_empty
  end
end
