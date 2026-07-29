require "./spec_helper"

describe TreeSitterManager::Parser::LanguageResolver do
  it "resolves a language from a file extension" do
    resolver = TreeSitterManager::Parser::LanguageResolver.new

    resolver.language_for_file("example.cr").should eq("crystal")
    resolver.grammar_language_for_file("example.go").should eq("go")
  end

  it "returns nil for unsupported extensions" do
    TreeSitterManager::Parser::LanguageResolver.new.language_for_file("fixture.unknown").should be_nil
  end
end
