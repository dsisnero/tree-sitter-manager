require "./spec_helper"
require "file_utils"

describe TreeSitterManager::GrammarLoader do
  it "searches the manager-owned grammar directory environment variable" do
    root = File.join(Dir.tempdir, "tsm-loader-#{Random.rand(1_000_000)}")
    language = "loader-fixture"
    symbol = TreeSitterManager::LanguageRegistry.c_symbol_for(language)
    library = File.join(root, TreeSitterManager::Platform.lib_name(symbol))
    previous_manager_root = ENV["TREE_SITTER_MANAGER_GRAMMAR_DIR"]?
    previous_chiasmus_root = ENV["CHIASMUS_GRAMMAR_DIR"]?

    begin
      Dir.mkdir_p(root)
      File.write(library, "fixture")
      ENV["TREE_SITTER_MANAGER_GRAMMAR_DIR"] = root
      ENV.delete("CHIASMUS_GRAMMAR_DIR")

      TreeSitterManager::GrammarLoader.find_grammar_library(language).should eq(library)
    ensure
      if previous_manager_root
        ENV["TREE_SITTER_MANAGER_GRAMMAR_DIR"] = previous_manager_root
      else
        ENV.delete("TREE_SITTER_MANAGER_GRAMMAR_DIR")
      end
      if previous_chiasmus_root
        ENV["CHIASMUS_GRAMMAR_DIR"] = previous_chiasmus_root
      else
        ENV.delete("CHIASMUS_GRAMMAR_DIR")
      end
      TreeSitterManager::GrammarLoader.clear_registered_directories_for_test
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "prefers the manager-owned grammar directory over the legacy variable" do
    manager_root = File.join(Dir.tempdir, "tsm-loader-manager-#{Random.rand(1_000_000)}")
    legacy_root = File.join(Dir.tempdir, "tsm-loader-legacy-#{Random.rand(1_000_000)}")
    language = "loader-precedence"
    symbol = TreeSitterManager::LanguageRegistry.c_symbol_for(language)
    manager_library = File.join(manager_root, TreeSitterManager::Platform.lib_name(symbol))
    legacy_library = File.join(legacy_root, TreeSitterManager::Platform.lib_name(symbol))
    previous_manager_root = ENV["TREE_SITTER_MANAGER_GRAMMAR_DIR"]?
    previous_chiasmus_root = ENV["CHIASMUS_GRAMMAR_DIR"]?

    begin
      Dir.mkdir_p(manager_root)
      Dir.mkdir_p(legacy_root)
      File.write(manager_library, "manager fixture")
      File.write(legacy_library, "legacy fixture")
      ENV["TREE_SITTER_MANAGER_GRAMMAR_DIR"] = manager_root
      ENV["CHIASMUS_GRAMMAR_DIR"] = legacy_root

      TreeSitterManager::GrammarLoader.find_grammar_library(language).should eq(manager_library)
    ensure
      if previous_manager_root
        ENV["TREE_SITTER_MANAGER_GRAMMAR_DIR"] = previous_manager_root
      else
        ENV.delete("TREE_SITTER_MANAGER_GRAMMAR_DIR")
      end
      if previous_chiasmus_root
        ENV["CHIASMUS_GRAMMAR_DIR"] = previous_chiasmus_root
      else
        ENV.delete("CHIASMUS_GRAMMAR_DIR")
      end
      TreeSitterManager::GrammarLoader.clear_registered_directories_for_test
      FileUtils.rm_rf(manager_root) if Dir.exists?(manager_root)
      FileUtils.rm_rf(legacy_root) if Dir.exists?(legacy_root)
    end
  end

  it "finds a library nested inside a configured grammar sidecar" do
    root = File.join(Dir.tempdir, "tsm-loader-nested-#{Random.rand(1_000_000)}")
    language = "loader-nested"
    symbol = TreeSitterManager::LanguageRegistry.c_symbol_for(language)
    nested = File.join(root, "releases", "current", "grammars")
    library = File.join(nested, TreeSitterManager::Platform.lib_name(symbol))
    previous_manager_root = ENV["TREE_SITTER_MANAGER_GRAMMAR_DIR"]?
    previous_chiasmus_root = ENV["CHIASMUS_GRAMMAR_DIR"]?

    begin
      Dir.mkdir_p(nested)
      File.write(library, "fixture")
      ENV["TREE_SITTER_MANAGER_GRAMMAR_DIR"] = root
      ENV.delete("CHIASMUS_GRAMMAR_DIR")

      TreeSitterManager::GrammarLoader.find_grammar_library(language).should eq(library)
    ensure
      if previous_manager_root
        ENV["TREE_SITTER_MANAGER_GRAMMAR_DIR"] = previous_manager_root
      else
        ENV.delete("TREE_SITTER_MANAGER_GRAMMAR_DIR")
      end
      if previous_chiasmus_root
        ENV["CHIASMUS_GRAMMAR_DIR"] = previous_chiasmus_root
      else
        ENV.delete("CHIASMUS_GRAMMAR_DIR")
      end
      TreeSitterManager::GrammarLoader.clear_registered_directories_for_test
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
