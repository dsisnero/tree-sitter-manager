require "./spec_helper"
require "file_utils"

describe TreeSitterManager::GrammarMetadataStore do
  it "creates metadata for nested tree-sitter grammar directories only" do
    root = File.join(Dir.tempdir, "tsm-metadata-#{Random.rand(1_000_000)}")
    container = File.join(root, "bundled")
    grammar_dir = File.join(container, "tree-sitter-fixture")

    begin
      Dir.mkdir_p(grammar_dir)
      File.write(File.join(grammar_dir, "grammar.js"), "module.exports = grammar({name: 'fixture'})")

      TreeSitterManager::GrammarMetadataStore.auto_create_for_existing(root).should be_true

      File.exists?(File.join(grammar_dir, TreeSitterManager::GrammarMetadataStore::METADATA_FILENAME)).should be_true
      File.exists?(File.join(container, TreeSitterManager::GrammarMetadataStore::METADATA_FILENAME)).should be_false
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
