require "./spec_helper"
require "file_utils"

describe TreeSitterManager::GrammarManager do
  it "routes synchronous installation through the coalesced installer path" do
    root = File.join(Dir.tempdir, "tsm-sync-install-#{Random::Secure.hex(8)}")
    seen = [] of String

    begin
      TreeSitterManager::GrammarManager.test_reset(root)
      manager = TreeSitterManager::GrammarManager.instance
      manager.set_install_hook_for_test { |language| seen << language; TreeSitterManager::BoolResult.success }

      manager.install_grammar_sync("fixture").success?.should be_true
      seen.should eq(["fixture"])
    ensure
      TreeSitterManager::GrammarManager.test_reset
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "checks tree-sitter installer manifests through the git update path" do
    root = File.join(Dir.tempdir, "tsm-tree-sitter-update-#{Random::Secure.hex(8)}")

    begin
      TreeSitterManager::GrammarManager.test_reset(root)
      TreeSitterManager::GrammarManager.init(root)
      language_dir = File.join(root, "fixture")
      TreeSitterManager::GrammarMetadataStore.save(language_dir, TreeSitterManager::GrammarMetadata.new(
        language: "fixture",
        type: "tree-sitter",
        package_name: "tree-sitter-fixture",
      )).should be_true

      result = TreeSitterManager::GrammarManager.instance.update_check_async("fixture").receive
      result.error.should eq("No URL for git grammar")
    ensure
      TreeSitterManager::GrammarManager.test_reset
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "checks cc installer manifests through the git update path" do
    root = File.join(Dir.tempdir, "tsm-cc-update-#{Random::Secure.hex(8)}")

    begin
      TreeSitterManager::GrammarManager.test_reset(root)
      TreeSitterManager::GrammarManager.init(root)
      language_dir = File.join(root, "fixture")
      TreeSitterManager::GrammarMetadataStore.save(language_dir, TreeSitterManager::GrammarMetadata.new(
        language: "fixture",
        type: "cc",
        package_name: "tree-sitter-fixture",
      )).should be_true

      result = TreeSitterManager::GrammarManager.instance.update_check_async("fixture").receive
      result.error.should eq("No URL for git grammar")
    ensure
      TreeSitterManager::GrammarManager.test_reset
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
