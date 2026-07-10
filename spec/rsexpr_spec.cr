require "./spec_helper"

describe TreeSitterManager::Sexpr do
  describe ".from_slice" do
    it "parses nested S-expressions" do
      result = TreeSitterManager::Sexpr.from_slice(%((("foo bar")(baz [1 2 3]))))
      result.should be_a(TreeSitterManager::Sexpr::Result(TreeSitterManager::Sexpr::Node))
      sexpr = result.unwrap
      sexpr.should be_a(TreeSitterManager::Sexpr::ListNode)
      list = sexpr.unwrap_list
      list.children.size.should eq(2)
    end

    it "fails on empty input" do
      result = TreeSitterManager::Sexpr.from_slice("")
      result.failure?.should be_true
    end

    it "fails on extra s-expressions" do
      result = TreeSitterManager::Sexpr.from_slice("(a) (b)")
      result.failure?.should be_true
    end

    it "parses atoms" do
      result = TreeSitterManager::Sexpr.from_slice("atom")
      result.unwrap.should be_a(TreeSitterManager::Sexpr::AtomNode)
    end

    it "parses strings" do
      result = TreeSitterManager::Sexpr.from_slice(%("hello"))
      result.unwrap.should be_a(TreeSitterManager::Sexpr::StringNode)
    end

    it "parses lists" do
      result = TreeSitterManager::Sexpr.from_slice("(a b c)")
      list = result.unwrap.unwrap_list
      list.children.size.should eq(3)
    end

    it "parses groups (square brackets)" do
      result = TreeSitterManager::Sexpr.from_slice("[a b c]")
      group = result.unwrap.unwrap_group
      group.children.size.should eq(3)
    end

    it "handles escaped quotes in strings" do
      result = TreeSitterManager::Sexpr.from_slice(%("\\"\\\\"))
      result.unwrap.unwrap_string.should eq(%("\\))
    end

    it "reports missing closing paren" do
      result = TreeSitterManager::Sexpr.from_slice("(a b")
      result.failure?.should be_true
    end

    it "reports extra closing paren" do
      result = TreeSitterManager::Sexpr.from_slice("(a b))")
      result.failure?.should be_true
    end
  end

  describe ".from_slice_multi" do
    it "parses multiple S-expressions" do
      result = TreeSitterManager::Sexpr.from_slice_multi(%(("foo bar") (baz [1 2 3])))
      result.unwrap.children.size.should eq(2)
    end

    it "parses atoms at root level" do
      result = TreeSitterManager::Sexpr.from_slice_multi(%(a b c))
      result.unwrap.children.size.should eq(3)
    end

    it "returns empty list for empty input" do
      result = TreeSitterManager::Sexpr.from_slice_multi("")
      result.unwrap.children.empty?.should be_true
    end
  end

  describe "to_s" do
    it "compact output for simple expressions" do
      sexpr = TreeSitterManager::Sexpr.from_slice("[ a b c ]").unwrap
      sexpr.to_s.should eq("[a b c]")
    end

    it "pretty output with indent" do
      sexpr = TreeSitterManager::Sexpr.from_slice("[ a b c ]").unwrap
      pretty = sexpr.to_s_pretty(2)
      pretty.should eq("[\n  a\n  b\n  c\n]")
    end

    it "compact output for atoms" do
      sexpr = TreeSitterManager::Sexpr.from_slice("atom").unwrap
      sexpr.to_s.should eq("atom")
    end

    it "compact output for strings" do
      sexpr = TreeSitterManager::Sexpr.from_slice(%("hello")).unwrap
      sexpr.to_s.should eq(%("hello"))
    end

    it "escapes special chars in strings" do
      sexpr = TreeSitterManager::Sexpr::StringNode.new("hello\\\"world")
      sexpr.to_s.should eq(%("hello\\\\\\"world"))
    end
  end

  describe "unwrap helpers" do
    it "unwraps lists" do
      sexpr = TreeSitterManager::Sexpr.from_slice("(a)").unwrap
      sexpr.unwrap_list.children.size.should eq(1)
    end

    it "unwraps groups" do
      sexpr = TreeSitterManager::Sexpr.from_slice("[a]").unwrap
      sexpr.unwrap_group.children.size.should eq(1)
    end

    it "unwraps strings" do
      sexpr = TreeSitterManager::Sexpr.from_slice(%("hello")).unwrap
      sexpr.unwrap_string.should eq("hello")
    end

    it "unwraps atoms" do
      sexpr = TreeSitterManager::Sexpr.from_slice("atom").unwrap
      sexpr.unwrap_atom.should eq("atom")
    end

    it "raises on wrong unwrap type" do
      sexpr = TreeSitterManager::Sexpr.from_slice("atom").unwrap
      expect_raises(Exception) { sexpr.unwrap_list }
    end
  end
end
