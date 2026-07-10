require "./spec_helper"
require "file_utils"

describe TreeSitterManager::QueryPreprocessor do
  describe ".process_highlights_with_inherits" do
    it "resolves inherits directive for c language" do
      result = TreeSitterManager::QueryPreprocessor.process_highlights_with_inherits(
        "non-crates.io", true, "c", "queries",
      )
      result.should be_a(String)
      result.size.should be > 0
    end
  end

  describe ".process_injections_with_inherits" do
    it "processes markdown injections with inherits" do
      result = TreeSitterManager::QueryPreprocessor.process_injections_with_inherits(
        "non-crates.io", true, "markdown", "queries",
      )
      result.should be_a(String)
    end
  end

  describe ".process_locals_with_inherits" do
    it "processes c locals with inherits" do
      result = TreeSitterManager::QueryPreprocessor.process_locals_with_inherits(
        "non-crates.io", true, "c", "queries",
      )
      result.should be_a(String)
    end
  end

  describe ".process" do
    it "strips patterns following skip comments" do
      src = <<-SCM
        (pattern_a) @a
        ; crates.io skip
        (pattern_b) @b
        (pattern_c) @c
      SCM

      result = TreeSitterManager::QueryPreprocessor.process(
        src,
        processor: nil,
        strip_comment: "; crates.io skip",
      )

      result.should contain("@a")
      result.should contain("@c")
      result.should_not contain("@b")
    end

    it "rewrites #lua-match? predicates" do
      src = "((identifier) @const (#lua-match? @const \"^[A-Z]\"))"
      result = TreeSitterManager::QueryPreprocessor.process(
        src,
        processor: ->(nodes : TreeSitterManager::Sexpr::Nodes) { nodes.children.each { |n| TreeSitterManager::QueryPreprocessor.replace_predicates(n) } },
        strip_comment: "crates.io",
      )

      result.should contain("#match?")
      result.should contain("[A-Z]")
      result.should_not contain("#lua-match?")
    end

    it "rewrites #any-of? predicates" do
      src = "((identifier) @type (#any-of? @type \"if\" \"for\" \"while\"))"
      result = TreeSitterManager::QueryPreprocessor.process(
        src,
        processor: ->(nodes : TreeSitterManager::Sexpr::Nodes) { nodes.children.each { |n| TreeSitterManager::QueryPreprocessor.replace_predicates(n) } },
        strip_comment: "crates.io",
      )

      result.should contain("#match?")
      result.should contain("if|for|while")
      result.should_not contain("#any-of?")
    end

    it "rewrites #contains? predicates" do
      src = "((identifier) @name (#contains? @name \"test\"))"
      result = TreeSitterManager::QueryPreprocessor.process(
        src,
        processor: ->(nodes : TreeSitterManager::Sexpr::Nodes) { nodes.children.each { |n| TreeSitterManager::QueryPreprocessor.replace_predicates(n) } },
        strip_comment: "crates.io",
      )

      result.should contain("#match?")
      result.should contain("test")
      result.should_not contain("#contains?")
    end

    it "removes empty groups" do
      src = "(pattern) @a"
      result = TreeSitterManager::QueryPreprocessor.process(src, processor: nil, strip_comment: "crates.io")
      result.should_not be_empty
    end
  end
end
