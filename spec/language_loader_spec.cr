require "./spec_helper"
require "file_utils"

describe TreeSitterManager::LanguageLoader do
  it "returns nil when a vendored grammar library is missing" do
    root = File.join(Dir.tempdir, "tsm-language-loader-#{Random.rand(1_000_000)}")
    Dir.mkdir_p(File.join(root, "tree-sitter-cpp"))
    previous_manager_root = ENV[TreeSitterManager::GrammarLoader::ENVIRONMENT_GRAMMAR_DIRECTORY]?
    previous_chiasmus_root = ENV[TreeSitterManager::GrammarLoader::LEGACY_ENVIRONMENT_GRAMMAR_DIRECTORY]?

    begin
      ENV[TreeSitterManager::GrammarLoader::ENVIRONMENT_GRAMMAR_DIRECTORY] = root
      ENV.delete(TreeSitterManager::GrammarLoader::LEGACY_ENVIRONMENT_GRAMMAR_DIRECTORY)

      TreeSitterManager::LanguageLoader.load_language_from_grammar_path("cpp", nil).should be_nil
    ensure
      if previous_manager_root
        ENV[TreeSitterManager::GrammarLoader::ENVIRONMENT_GRAMMAR_DIRECTORY] = previous_manager_root
      else
        ENV.delete(TreeSitterManager::GrammarLoader::ENVIRONMENT_GRAMMAR_DIRECTORY)
      end
      if previous_chiasmus_root
        ENV[TreeSitterManager::GrammarLoader::LEGACY_ENVIRONMENT_GRAMMAR_DIRECTORY] = previous_chiasmus_root
      else
        ENV.delete(TreeSitterManager::GrammarLoader::LEGACY_ENVIRONMENT_GRAMMAR_DIRECTORY)
      end
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
