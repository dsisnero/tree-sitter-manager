require "./spec_helper"
require "file_utils"

describe TreeSitterManager::GrammarQuery do
  it "finds a grammar in a registered sidecar directory without initializing the manager" do
    root = File.join(Dir.tempdir, "tsm-query-#{Random.rand(1_000_000)}")
    language = "query-fixture"
    symbol = TreeSitterManager::LanguageRegistry.c_symbol_for(language)
    library = File.join(root, TreeSitterManager::Platform.lib_name(symbol))

    begin
      Dir.mkdir_p(root)
      File.write(library, "fixture")
      TreeSitterManager::GrammarLoader.register_grammar_directory(root)

      TreeSitterManager::GrammarQuery.path(language).should eq(library)
      TreeSitterManager::GrammarQuery.available?(language).should be_true
    ensure
      TreeSitterManager::GrammarLoader.clear_registered_directories_for_test
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "returns sidecar lookups through a channel" do
    root = File.join(Dir.tempdir, "tsm-query-async-#{Random.rand(1_000_000)}")
    language = "query-async-fixture"
    symbol = TreeSitterManager::LanguageRegistry.c_symbol_for(language)
    library = File.join(root, TreeSitterManager::Platform.lib_name(symbol))

    begin
      Dir.mkdir_p(root)
      File.write(library, "fixture")
      TreeSitterManager::GrammarLoader.register_grammar_directory(root)

      TreeSitterManager::GrammarQuery.path_async(language).receive.should eq(library)
      TreeSitterManager::GrammarQuery.available_async(language).receive.should be_true
    ensure
      TreeSitterManager::GrammarLoader.clear_registered_directories_for_test
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
