require "./spec_helper"

describe "Language Registry from languages.toml" do
  it "registers the discovery languages required by Chiasmus" do
    {
      "rust"       => "rs",
      "csharp"     => "cs",
      "typescript" => "ts",
      "python"     => "py",
      "ruby"       => "rb",
      "go"         => "go",
    }.each do |language, extension|
      TreeSitterManager::LanguageRegistry.get_language_info(language).should_not be_nil
      TreeSitterManager::LanguageRegistry.language_for_extension(extension).should eq(language)
    end
  end

  it "has git_url for crystal" do
    info = TreeSitterManager::LanguageRegistry.get_language_info("crystal")
    info.should_not be_nil
    info = info.not_nil!
    info.git_url.should contain("tree-sitter-crystal")
  end

  it "has git_rev pinned for crystal" do
    info = TreeSitterManager::LanguageRegistry.get_language_info("crystal")
    info.not_nil!.git_rev.should_not be_empty
  end

  it "has ffi_func for crystal" do
    info = TreeSitterManager::LanguageRegistry.get_language_info("crystal")
    info.not_nil!.ffi_func.should eq("tree_sitter_crystal")
  end

  it "has git_url for python from tree-sitter org" do
    info = TreeSitterManager::LanguageRegistry.get_language_info("python")
    info.should_not be_nil
    info.not_nil!.git_url.should contain("tree-sitter/tree-sitter-python")
  end

  it "has git_rev for python" do
    info = TreeSitterManager::LanguageRegistry.get_language_info("python")
    info.not_nil!.git_rev.size.should be >= 40 # SHA hash
  end

  it "has git_url for rust" do
    info = TreeSitterManager::LanguageRegistry.get_language_info("rust")
    info.not_nil!.git_url.should contain("tree-sitter/tree-sitter-rust")
  end

  it "all languages with queries have git_url" do
    # Spot-check a few
    %w[python rust go javascript typescript c cpp ruby bash].each do |lang|
      info = TreeSitterManager::LanguageRegistry.get_language_info(lang)
      info.should_not be_nil, "missing #{lang}"
      info.not_nil!.git_url.should_not be_empty, "#{lang} has no git_url"
    end
  end
end

describe "LanguageRegistry aliases" do
  it "resolves 'shell' to 'bash'" do
    TreeSitterManager::LanguageRegistry.resolve_alias("shell").should eq("bash")
  end

  it "resolves 'makefile' to 'make'" do
    TreeSitterManager::LanguageRegistry.resolve_alias("makefile").should eq("make")
  end

  it "resolves 'lisp' to 'commonlisp'" do
    TreeSitterManager::LanguageRegistry.resolve_alias("lisp").should eq("commonlisp")
  end

  it "passes through unknown names unchanged" do
    TreeSitterManager::LanguageRegistry.resolve_alias("python").should eq("python")
    TreeSitterManager::LanguageRegistry.resolve_alias("nonexistent").should eq("nonexistent")
  end

  it "get_language_info resolves aliases" do
    shell_info = TreeSitterManager::LanguageRegistry.get_language_info("shell")
    bash_info = TreeSitterManager::LanguageRegistry.get_language_info("bash")
    shell_info.should_not be_nil
    shell_info.not_nil!.name.should eq("bash")
  end
end

describe "LanguageRegistry C symbol overrides" do
  it "resolves 'csharp' symbol to 'c_sharp'" do
    TreeSitterManager::LanguageRegistry.c_symbol_for("csharp").should eq("c_sharp")
  end

  it "resolves 'c-sharp' symbol to 'c_sharp'" do
    TreeSitterManager::LanguageRegistry.c_symbol_for("c-sharp").should eq("c_sharp")
  end

  it "passes through names without overrides" do
    TreeSitterManager::LanguageRegistry.c_symbol_for("python").should eq("python")
    TreeSitterManager::LanguageRegistry.c_symbol_for("rust").should eq("rust")
  end
end

describe "LanguageRegistry semantic groups" do
  it "has languages_in_group returning array of language names" do
    # "scripting" group includes python, ruby, javascript, etc.
    langs = TreeSitterManager::LanguageRegistry.languages_in_group("scripting")
    langs.should be_a(Array(String))
    langs.should_not be_empty
  end

  it "returns empty array for unknown group" do
    TreeSitterManager::LanguageRegistry.languages_in_group("nonexistent").should be_empty
  end
end

describe "LanguageRegistry ambiguous extensions" do
  it "registers ambiguous extensions" do
    TreeSitterManager::LanguageRegistry.register_ambiguous_extension("m", "matlab")
    amb = TreeSitterManager::LanguageRegistry.ambiguous_for("m")
    amb.should contain("matlab")
  end

  it "lists candidates for ambiguous extensions" do
    TreeSitterManager::LanguageRegistry.register_ambiguous_extension("m", "objc")
    TreeSitterManager::LanguageRegistry.register_ambiguous_extension("m", "matlab")
    candidates = TreeSitterManager::LanguageRegistry.ambiguous_for("m")
    candidates.should contain("objc")
    candidates.should contain("matlab")
  end

  it "resolves language for extension, preferring unambiguous match" do
    lang = TreeSitterManager::LanguageRegistry.language_for_extension("py")
    lang.should eq("python")
  end

  it "accepts extensions with a leading dot" do
    TreeSitterManager::LanguageRegistry.language_for_extension(".cr").should eq("crystal")
  end
end

describe "LanguageRegistry custom languages" do
  it "registers and unregisters a custom language without recursive locking" do
    TreeSitterManager::LanguageRegistry.clear_cache
    info = TreeSitterManager::LanguageRegistry::LanguageInfo.new(
      name: "demo",
      package: "tree-sitter-demo",
      extensions: [".demo"]
    )

    TreeSitterManager::LanguageRegistry.register_language(info)
    TreeSitterManager::LanguageRegistry.language_for_extension("demo").should eq("demo")
    TreeSitterManager::LanguageRegistry.unregister_language("demo")
    TreeSitterManager::LanguageRegistry.language_for_extension("demo").should be_nil
  end
end

describe "GrammarManager install uses TOML git_url" do
  it "uses correct git URL from registry for crystal" do
    url = TreeSitterManager::LanguageRegistry.git_url_for("crystal")
    url.should_not be_nil
    url.not_nil!.should contain("tree-sitter-crystal")
  end
end
