require "./spec_helper"

describe TreeSitterManager::LuaPattern do
  describe ".parse" do
    it "parses character classes" do
      result = TreeSitterManager::LuaPattern.parse("%l")
      result.size.should eq(1)
      result[0].should be_a(TreeSitterManager::LuaPattern::PatternClass)
      result[0].as(TreeSitterManager::LuaPattern::PatternClass).cls.should eq(TreeSitterManager::LuaPattern::Class::Lowercase)
    end

    it "parses any character" do
      result = TreeSitterManager::LuaPattern.parse(".")
      result[0].should be_a(TreeSitterManager::LuaPattern::PatternAny)
    end

    it "parses start anchor" do
      result = TreeSitterManager::LuaPattern.parse("^abc")
      result[0].should be_a(TreeSitterManager::LuaPattern::PatternStart)
      result[1].should be_a(TreeSitterManager::LuaPattern::PatternString)
    end

    it "parses end anchor" do
      result = TreeSitterManager::LuaPattern.parse("abc$")
      result[0].should be_a(TreeSitterManager::LuaPattern::PatternString)
      result[1].should be_a(TreeSitterManager::LuaPattern::PatternEnd)
    end

    it "parses escaped characters" do
      result = TreeSitterManager::LuaPattern.parse("%%")
      result[0].should be_a(TreeSitterManager::LuaPattern::PatternEscaped)
    end

    it "parses quantifiers" do
      result = TreeSitterManager::LuaPattern.parse("a+")
      result[0].should be_a(TreeSitterManager::LuaPattern::PatternQuantifier)
      q = result[0].as(TreeSitterManager::LuaPattern::PatternQuantifier)
      q.quantifier.should eq(TreeSitterManager::LuaPattern::Quantifier::OneOrMore)
    end

    it "parses sets" do
      result = TreeSitterManager::LuaPattern.parse("[a-z]")
      result[0].should be_a(TreeSitterManager::LuaPattern::PatternSet)
      s = result[0].as(TreeSitterManager::LuaPattern::PatternSet)
      s.inverted.should be_false
      s.set_children.size.should eq(1)
    end

    it "parses capture groups" do
      result = TreeSitterManager::LuaPattern.parse("(a)")
      result[0].should be_a(TreeSitterManager::LuaPattern::PatternCapture)
    end

    it "parses the comprehensive test pattern" do
      input = "^^charsq+w-e*r?.%.(%a%c%d%g%l%p%s%u%w%x%z%A)"
      result = TreeSitterManager::LuaPattern.parse(input)
      result.size.should eq(8)
    end

    it "errors on unfinished escape" do
      expect_raises(TreeSitterManager::LuaPattern::Error) do
        TreeSitterManager::LuaPattern.parse("a%")
      end
    end
  end

  describe ".to_regex" do
    it "converts character classes" do
      pattern = TreeSitterManager::LuaPattern.parse("%l")
      TreeSitterManager::LuaPattern.to_regex(pattern, false, false).should eq("[a-z]")
    end

    it "converts any to regex" do
      pattern = TreeSitterManager::LuaPattern.parse(".")
      TreeSitterManager::LuaPattern.to_regex(pattern, false, false).should eq("[\\s\\S]")
    end

    it "converts starts and ends" do
      pattern = TreeSitterManager::LuaPattern.parse("^a$")
      TreeSitterManager::LuaPattern.to_regex(pattern, false, false).should eq("^a$")
    end

    it "converts escaped chars" do
      pattern = TreeSitterManager::LuaPattern.parse("%.")
      TreeSitterManager::LuaPattern.to_regex(pattern, false, false).should eq("\\.")
    end

    it "converts quantifiers" do
      pattern = TreeSitterManager::LuaPattern.parse("a*")
      TreeSitterManager::LuaPattern.to_regex(pattern, false, false).should eq("a*")
    end

    it "converts lazy quantifier to regex" do
      pattern = TreeSitterManager::LuaPattern.parse("a-")
      TreeSitterManager::LuaPattern.to_regex(pattern, false, false).should eq("a*?")
    end

    it "converts sets" do
      pattern = TreeSitterManager::LuaPattern.parse("[a-z_]")
      TreeSitterManager::LuaPattern.to_regex(pattern, false, false).should eq("[a-z_]")
    end

    it "converts inverted sets" do
      pattern = TreeSitterManager::LuaPattern.parse("[^abc]")
      TreeSitterManager::LuaPattern.to_regex(pattern, false, false).should eq("[^abc]")
    end

    it "escapes special regex chars in strings" do
      pattern = TreeSitterManager::LuaPattern.parse("hello%.world")
      TreeSitterManager::LuaPattern.to_regex(pattern, false, false).should eq("hello\\.world")
    end

    it "converts captures to groups" do
      pattern = TreeSitterManager::LuaPattern.parse("(ab)")
      TreeSitterManager::LuaPattern.to_regex(pattern, false, false).should eq("(ab)")
    end

    it "errors on balanced patterns" do
      pattern = TreeSitterManager::LuaPattern.parse("%b()")
      expect_raises(TreeSitterManager::LuaPattern::ToRegexError) do
        TreeSitterManager::LuaPattern.to_regex(pattern, false, false)
      end
    end

    it "converts the comprehensive pattern" do
      input = "^^charsq+w-e*r?.%.(%a%c%d%g%l%p%s%u%w%x%z%A)"
      pattern = TreeSitterManager::LuaPattern.parse(input)
      expected = "^\\^charsq+w*?e*r?[\\s\\S]\\.([a-zA-Z][\\0-\\31][0-9][\\33-\\126][a-z][!\"\\#$%&'()*+,\\-./:;<=>?@\\[\\\\\\]^_`{|}\u{7e}][ \\t\\n\\v\\f\\r][A-Z][a-zA-Z0-9][0-9a-fA-F]\\0[^a-zA-Z])"
      TreeSitterManager::LuaPattern.to_regex(pattern, false, false).should eq(expected)
    end
  end
end
