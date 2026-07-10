require "./spec_helper"

describe TreeSitterManager::QueryManager do
  describe ".load_queries" do
    it "loads highlight queries for a language" do
      queries = TreeSitterManager::QueryManager.load_queries("rust", "queries")

      queries.should be_a(TreeSitterManager::QueryManager::PreprocessedQueries)
      queries.highlights.should_not be_empty
    end

    it "loads injection queries" do
      queries = TreeSitterManager::QueryManager.load_queries("markdown", "queries")

      queries.should be_a(TreeSitterManager::QueryManager::PreprocessedQueries)
      queries.injections.should_not be_empty
    end

    it "loads locals queries" do
      queries = TreeSitterManager::QueryManager.load_queries("c", "queries")

      queries.should be_a(TreeSitterManager::QueryManager::PreprocessedQueries)
      queries.locals.should_not be_empty
    end

    it "handles languages without query files" do
      queries = TreeSitterManager::QueryManager.load_queries("nonexistent_lang", "queries")

      queries.should be_a(TreeSitterManager::QueryManager::PreprocessedQueries)
      queries.highlights.should eq("")
    end

    it "resolves inherits in highlight queries" do
      queries = TreeSitterManager::QueryManager.load_queries("html", "queries")

      # HTML inherits from html_tags — should contain tag captures
      queries.highlights.should contain("@tag")
    end

    it "rewrites nvim predicates in queries" do
      queries = TreeSitterManager::QueryManager.load_queries("rust", "queries")

      # Rust queries use #lua-match? which should be converted
      queries.highlights.should_not contain("#lua-match?")
    end
  end

  describe ".create_configuration" do
    it "creates a HighlightConfiguration from loaded queries" do
      config = TreeSitterManager::QueryManager.create_configuration("python", "queries")

      config.should be_a(TreeSitterManager::HighlightConfiguration)
      config.language_name.should eq("python")
      config.highlight_pattern_count.should be > 0
    end

    it "detects injection support" do
      config = TreeSitterManager::QueryManager.create_configuration("markdown", "queries")

      config.has_injections?.should be_true
    end
  end

  describe ".cached?" do
    it "returns false before loading" do
      TreeSitterManager::QueryManager.clear_cache
      TreeSitterManager::QueryManager.cached?("python").should be_false
    end

    it "returns true after loading" do
      TreeSitterManager::QueryManager.load_queries("python", "queries")
      TreeSitterManager::QueryManager.cached?("python").should be_true
    end
  end

  describe ".clear_cache" do
    it "clears cached queries" do
      TreeSitterManager::QueryManager.load_queries("python", "queries")
      TreeSitterManager::QueryManager.clear_cache
      TreeSitterManager::QueryManager.cached?("python").should be_false
    end
  end

  describe ".available_languages" do
    it "lists languages with query directories" do
      langs = TreeSitterManager::QueryManager.available_languages("queries")
      langs.should contain("rust")
      langs.should contain("python")
      langs.should contain("go")
    end
  end
end

describe TreeSitterManager::QueryKind do
  it "has six query kinds" do
    TreeSitterManager::QueryKind::Highlights.should_not be_nil
    TreeSitterManager::QueryKind::Folds.should_not be_nil
    TreeSitterManager::QueryKind::Indents.should_not be_nil
    TreeSitterManager::QueryKind::Injections.should_not be_nil
    TreeSitterManager::QueryKind::Locals.should_not be_nil
    TreeSitterManager::QueryKind::Tags.should_not be_nil
  end
end

describe TreeSitterManager::QueryManager do
  describe "extended query types" do
    it "PreprocessedQueries has folds field" do
      queries = TreeSitterManager::QueryManager.load_queries("rust", "queries")
      queries.responds_to?(:folds).should be_true
    end

    it "PreprocessedQueries has indents field" do
      queries = TreeSitterManager::QueryManager.load_queries("rust", "queries")
      queries.responds_to?(:indents).should be_true
    end

    it "PreprocessedQueries has tags field" do
      queries = TreeSitterManager::QueryManager.load_queries("rust", "queries")
      queries.responds_to?(:tags).should be_true
    end
  end
end
