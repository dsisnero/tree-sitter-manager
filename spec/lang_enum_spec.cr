require "./spec_helper"

describe TreeSitterManager::LanguageRegistry::Lang do
  it "has enum members for common languages from TOML" do
    TreeSitterManager::LanguageRegistry::Lang::Bash.should be_a(TreeSitterManager::LanguageRegistry::Lang)
    TreeSitterManager::LanguageRegistry::Lang::Rust.should be_a(TreeSitterManager::LanguageRegistry::Lang)
    TreeSitterManager::LanguageRegistry::Lang::Python.should be_a(TreeSitterManager::LanguageRegistry::Lang)
  end

  it "has name returning the language name" do
    TreeSitterManager::LanguageRegistry::Lang::Bash.name.should eq("bash")
    TreeSitterManager::LanguageRegistry::Lang::Ruby.name.should eq("ruby")
  end

  it "has parse? for string-to-enum lookup" do
    TreeSitterManager::LanguageRegistry::Lang.parse?("bash").should eq(TreeSitterManager::LanguageRegistry::Lang::Bash)
    TreeSitterManager::LanguageRegistry::Lang.parse?("nonexistent").should be_nil
  end

  it "has LANGUAGE_NAMES array constant" do
    names = TreeSitterManager::LanguageRegistry::LANGUAGE_NAMES
    names.should be_a(Array(String))
    names.should contain("bash")
    names.should contain("rust")
    names.should contain("python")
  end

  it "has 300+ languages from language-pack" do
    names = TreeSitterManager::LanguageRegistry::LANGUAGE_NAMES
    names.size.should be >= 300
  end

  it "generated data includes real file extensions" do
    lang = TreeSitterManager::LanguageRegistryGenerated::LANGUAGES.find { |l| l["name"] == "python" }
    lang.should_not be_nil
    lang = lang.not_nil!
    lang["extensions"].should contain("py")
  end

  it "generated data includes abi_version" do
    lang = TreeSitterManager::LanguageRegistryGenerated::LANGUAGES.find { |l| l["name"] == "python" }
    lang.should_not be_nil
    lang = lang.not_nil!
    lang["abi_version"].should_not be_nil
  end
end
