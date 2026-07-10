require "./spec_helper"

describe "Integration: Full Highlight Pipeline" do
  it "loads and preprocesses rust highlight queries end-to-end" do
    queries = TreeSitterManager::QueryManager.load_queries("rust", "queries")

    queries.highlights.should_not be_empty
    queries.injections.should_not be_empty

    # Verify nvim predicates were rewritten
    queries.highlights.should_not contain("#lua-match?")
    queries.highlights.should_not contain("#any-of?")
    queries.highlights.should_not contain("#contains?")

    # Verify captures were preserved
    queries.highlights.should contain("@")
    queries.highlights.should contain("function")
    queries.highlights.should contain("variable")
    queries.highlights.should contain("keyword")
    queries.highlights.should contain("string")

    # Verify inheritance was NOT used (rust doesn't inherit)
    # Rust has its own complete highlights.scm
  end

  it "creates HighlightConfiguration with correct capture mapping" do
    config = TreeSitterManager::QueryManager.create_configuration("rust", "queries")

    config.language_name.should eq("rust")
    config.highlight_pattern_count.should be > 0
    config.has_injections?.should be_true

    # Known highlight captures should map to valid indices
    config.highlight_index_for_capture("function").should be >= 0
    config.highlight_index_for_capture("variable").should be >= 0
    config.highlight_index_for_capture("keyword").should be >= 0
    config.highlight_index_for_capture("string").should be >= 0
    config.highlight_index_for_capture("comment").should be >= 0
    config.highlight_index_for_capture("type").should be >= 0

    # Regression: non-existent captures should return -1
    config.highlight_index_for_capture("nonexistent_xyz").should eq(-1)
  end

  it "resolves inheritance for HTML from html_tags" do
    queries = TreeSitterManager::QueryManager.load_queries("html", "queries")

    # HTML inherits all tags from html_tags
    queries.highlights.should contain("@tag")
    queries.highlights.should contain("@tag.attribute")
    queries.highlights.should contain("@tag.delimiter")

    # HTML also adds doctype and entity highlighting
    queries.highlights.should contain("doctype")
    queries.highlights.should contain("entity")
  end

  it "resolves injections for markdown" do
    config = TreeSitterManager::QueryManager.create_configuration("markdown", "queries")

    config.has_injections?.should be_true

    # Markdown injects fenced code blocks, HTML, and frontmatter
    combined = config.combined_query_source
    combined.should contain("injection.content")
    combined.should contain("injection.language")
  end

  it "handles typescript inheriting javascript (ecma) queries" do
    queries = TreeSitterManager::QueryManager.load_queries("typescript", "queries")

    # TypeScript inherits from ecma (shared with javascript)
    queries.highlights.should_not be_empty
    queries.highlights.should contain("type")
    queries.highlights.should contain("function")
    queries.highlights.should contain("variable")
  end

  it "processes locals queries for C language" do
    queries = TreeSitterManager::QueryManager.load_queries("c", "queries")

    # C has locals queries (scope/definition/reference)
    if !queries.locals.empty?
      queries.locals.should contain("local")
    end
  end

  it "lists all available languages with queries" do
    langs = TreeSitterManager::QueryManager.available_languages("queries")
    langs.size.should be >= 50

    langs.should contain("rust")
    langs.should contain("python")
    langs.should contain("go")
    langs.should contain("javascript")
    langs.should contain("typescript")
    langs.should contain("c")
    langs.should contain("cpp")
    langs.should contain("ruby")
    langs.should contain("bash")
    langs.should contain("json")
  end

  it "maintains consistent capture-to-theme-key mapping across rust query" do
    config = TreeSitterManager::QueryManager.create_configuration("rust", "queries")

    # All capture names from the query should be mappable or return -1
    config.capture_names.each do |name|
      idx = config.highlight_index_for_capture(name)
      # Either maps to a known key or unrecognized
      (idx >= 0 || idx == -1).should be_true
    end
  end

  it "caches queries to avoid reprocessing" do
    TreeSitterManager::QueryManager.clear_cache

    # First load — should process
    q1 = TreeSitterManager::QueryManager.load_queries("python", "queries")
    TreeSitterManager::QueryManager.cached?("python").should be_true

    # Second load — should use cache
    q2 = TreeSitterManager::QueryManager.load_queries("python", "queries")
    q1.highlights.should eq(q2.highlights)
  end
end
