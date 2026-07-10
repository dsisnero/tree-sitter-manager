require "./spec_helper"

describe "LanguageRegistry enhanced schema" do
  it "LanguageInfo has abi_version field" do
    info = TreeSitterManager::LanguageRegistry.get_language_info("python")
    info.should_not be_nil
    info = info.not_nil!
    # abi_version may be nil (unknown), but the field must exist on the record
    info.responds_to?(:abi_version).should be_true
  end

  it "LanguageInfo has c_symbol field" do
    info = TreeSitterManager::LanguageRegistry.get_language_info("csharp")
    info.should_not be_nil
    info = info.not_nil!
    info.responds_to?(:c_symbol).should be_true
  end

  it "c_symbol for csharp returns c_sharp" do
    TreeSitterManager::LanguageRegistry.c_symbol_for("csharp").should eq("c_sharp")
  end

  it "generator includes abi_version in generated LANGUAGES" do
    lang = TreeSitterManager::LanguageRegistryGenerated::LANGUAGES.find { |l| l["name"] == "python" }
    lang.should_not be_nil
    lang = lang.not_nil!
    lang.has_key?("abi_version").should be_true
  end

  it "LanguageInfo includes directory field for sub-repo grammars" do
    info = TreeSitterManager::LanguageRegistry.get_language_info("cpp")
    info.should_not be_nil
    info = info.not_nil!
    info.responds_to?(:parser_path).should be_true
  end
end
