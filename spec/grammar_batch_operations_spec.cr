require "./spec_helper"
require "../src/tree_sitter_manager/grammar_batch_operations"

describe TreeSitterManager::GrammarBatchOperations do
  describe "resolve_dependency_levels" do
    it "returns single level for independent languages" do
      langs = ["python", "ruby", "go"]
      deps = {} of String => Array(String)
      levels = TreeSitterManager::GrammarBatchOperations.resolve_dependency_levels(langs, deps)
      levels.size.should eq(1)
      levels[0].sort.should eq(langs.sort)
    end

    it "splits levels when dependencies exist" do
      langs = ["javascript", "typescript", "tsx", "python"]
      deps = {
        "typescript" => ["javascript"],
        "tsx"        => ["javascript"],
      }
      levels = TreeSitterManager::GrammarBatchOperations.resolve_dependency_levels(langs, deps)
      # Level 0: python, javascript (no dependencies)
      # Level 1: typescript, tsx (depend on javascript)
      levels.size.should eq(2)
      levels[0].sort.should eq(["javascript", "python"])
      levels[1].sort.should eq(["tsx", "typescript"])
    end

    it "handles empty language list" do
      levels = TreeSitterManager::GrammarBatchOperations.resolve_dependency_levels([] of String, {} of String => Array(String))
      levels.flatten.should be_empty
    end

    it "handles single language" do
      levels = TreeSitterManager::GrammarBatchOperations.resolve_dependency_levels(["python"], {} of String => Array(String))
      levels.size.should eq(1)
      levels[0].should eq(["python"])
    end

    it "handles chain of dependencies" do
      langs = ["a", "b", "c"]
      deps = {
        "b" => ["a"],
        "c" => ["b"],
      }
      levels = TreeSitterManager::GrammarBatchOperations.resolve_dependency_levels(langs, deps)
      levels.size.should eq(3)
      levels[0].should eq(["a"])
      levels[1].should eq(["b"])
      levels[2].should eq(["c"])
    end

    it "handles diamond dependencies" do
      langs = ["a", "b", "c", "d"]
      deps = {
        "b" => ["a"],
        "c" => ["a"],
        "d" => ["b", "c"],
      }
      levels = TreeSitterManager::GrammarBatchOperations.resolve_dependency_levels(langs, deps)
      levels.size.should eq(3)
      levels[0].should eq(["a"])
      levels[1].sort.should eq(["b", "c"])
      levels[2].should eq(["d"])
    end

    it "handles cyclic dependencies gracefully" do
      langs = ["a", "b"]
      deps = {
        "a" => ["b"],
        "b" => ["a"],
      }
      # Should not infinite loop; includes all langs even if cyclic
      levels = TreeSitterManager::GrammarBatchOperations.resolve_dependency_levels(langs, deps)
      levels.flatten.sort.should eq(langs.sort)
    end
  end

  describe "resolve_dependencies (legacy)" do
    it "returns flat order matching levels" do
      langs = ["javascript", "typescript", "python"]
      deps = {"typescript" => ["javascript"]}
      order = TreeSitterManager::GrammarBatchOperations.resolve_dependencies(langs, deps)
      js_idx = order.index("javascript")
      ts_idx = order.index("typescript")
      js_idx.should_not be_nil
      ts_idx.should_not be_nil
      js_idx.not_nil!.should be < ts_idx.not_nil!
    end
  end

  describe "MAX_WORKERS" do
    it "is a positive integer" do
      TreeSitterManager::GrammarBatchOperations::MAX_WORKERS.should be > 0
      TreeSitterManager::GrammarBatchOperations::MAX_WORKERS.should be <= 16
    end
  end
end
