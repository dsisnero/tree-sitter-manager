require "./spec_helper"
require "file_utils"
require "digest/sha256"

describe TreeSitterManager::ParserPack do
  it "installs a verified local bundle into the grammar cache" do
    root = File.join(Dir.tempdir, "tsm-parser-pack-#{Random::Secure.hex(8)}")
    bundle_dir = File.join(root, "bundle")
    cache_dir = File.join(root, "cache")
    library_dir = File.join(bundle_dir, "python")
    library_name = TreeSitterManager::Platform.grammar_library_name("python")
    library_path = File.join(library_dir, library_name)

    begin
      Dir.mkdir_p(library_dir)
      File.write(library_path, "fixture grammar")
      sha256 = Digest::SHA256.hexdigest(File.read(library_path))
      File.write(File.join(bundle_dir, "parser-pack.json"), {
        "version"  => 1,
        "platform" => TreeSitterManager::Platform.artifact_tag,
        "parsers"  => [{"language" => "python", "file" => "python/#{library_name}", "sha256" => sha256}],
      }.to_json)

      TreeSitterManager::ParserPack.install_from_directory(bundle_dir, cache_dir).should eq(["python"])
      File.read(File.join(cache_dir, "python", library_name)).should eq("fixture grammar")
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
      TreeSitterManager::GrammarLoader.clear_registered_directories_for_test
    end
  end

  it "installs canonical-symbol grammars where GrammarLoader can discover them" do
    root = File.join(Dir.tempdir, "tsm-parser-pack-csharp-#{Random::Secure.hex(8)}")
    bundle_dir = File.join(root, "bundle")
    cache_dir = File.join(root, "cache")
    language = "csharp"
    library_name = TreeSitterManager::Platform.grammar_library_name(language)
    library_path = File.join(bundle_dir, language, library_name)

    begin
      Dir.mkdir_p(File.dirname(library_path))
      File.write(library_path, "fixture grammar")
      File.write(File.join(bundle_dir, "parser-pack.json"), {
        "version"  => 1,
        "platform" => TreeSitterManager::Platform.artifact_tag,
        "parsers"  => [{"language" => language, "file" => "#{language}/#{library_name}", "sha256" => Digest::SHA256.hexdigest(File.read(library_path))}],
      }.to_json)

      TreeSitterManager::ParserPack.install_from_directory(bundle_dir, cache_dir)
      TreeSitterManager::GrammarLoader.find_grammar_library(language).should eq(
        File.join(cache_dir, language, TreeSitterManager::Platform.grammar_library_name("c_sharp"))
      )
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
      TreeSitterManager::GrammarLoader.clear_registered_directories_for_test
    end
  end

  it "rejects unsupported manifest versions" do
    root = File.join(Dir.tempdir, "tsm-parser-pack-version-#{Random::Secure.hex(8)}")
    bundle_dir = File.join(root, "bundle")

    begin
      Dir.mkdir_p(bundle_dir)
      File.write(File.join(bundle_dir, "parser-pack.json"), {
        "version"  => 2,
        "platform" => TreeSitterManager::Platform.artifact_tag,
        "parsers"  => [] of Hash(String, String),
      }.to_json)

      expect_raises(TreeSitterManager::ParserPack::Error, /Unsupported parser-pack manifest version/) do
        TreeSitterManager::ParserPack.install_from_directory(bundle_dir, File.join(root, "cache"))
      end
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "rejects a language name that escapes the grammar cache" do
    root = File.join(Dir.tempdir, "tsm-parser-pack-language-path-#{Random::Secure.hex(8)}")
    bundle_dir = File.join(root, "bundle")
    library_name = TreeSitterManager::Platform.grammar_library_name("python")
    library_path = File.join(bundle_dir, "python", library_name)

    begin
      Dir.mkdir_p(File.dirname(library_path))
      File.write(library_path, "fixture grammar")
      File.write(File.join(bundle_dir, "parser-pack.json"), {
        "version"  => 1,
        "platform" => TreeSitterManager::Platform.artifact_tag,
        "parsers"  => [{"language" => "../outside", "file" => "python/#{library_name}", "sha256" => Digest::SHA256.hexdigest(File.read(library_path))}],
      }.to_json)

      expect_raises(TreeSitterManager::ParserPack::Error, /Unsafe parser-pack language/) do
        TreeSitterManager::ParserPack.install_from_directory(bundle_dir, File.join(root, "cache"))
      end
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "rejects a parser file whose checksum does not match the manifest" do
    root = File.join(Dir.tempdir, "tsm-parser-pack-checksum-#{Random::Secure.hex(8)}")
    bundle_dir = File.join(root, "bundle")
    cache_dir = File.join(root, "cache")
    library_dir = File.join(bundle_dir, "python")
    library_name = TreeSitterManager::Platform.grammar_library_name("python")

    begin
      Dir.mkdir_p(library_dir)
      File.write(File.join(library_dir, library_name), "tampered grammar")
      File.write(File.join(bundle_dir, "parser-pack.json"), {
        "version"  => 1,
        "platform" => TreeSitterManager::Platform.artifact_tag,
        "parsers"  => [{"language" => "python", "file" => "python/#{library_name}", "sha256" => "0" * 64}],
      }.to_json)

      expect_raises(TreeSitterManager::ParserPack::ChecksumError) do
        TreeSitterManager::ParserPack.install_from_directory(bundle_dir, cache_dir)
      end
      Dir.exists?(cache_dir).should be_false
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "rejects a manifest path that escapes the bundle directory" do
    root = File.join(Dir.tempdir, "tsm-parser-pack-path-#{Random::Secure.hex(8)}")
    bundle_dir = File.join(root, "bundle")

    begin
      Dir.mkdir_p(bundle_dir)
      File.write(File.join(bundle_dir, "parser-pack.json"), {
        "version"  => 1,
        "platform" => TreeSitterManager::Platform.artifact_tag,
        "parsers"  => [{"language" => "python", "file" => "../outside", "sha256" => "0" * 64}],
      }.to_json)

      expect_raises(TreeSitterManager::ParserPack::Error, /Unsafe parser-pack path/) do
        TreeSitterManager::ParserPack.install_from_directory(bundle_dir, File.join(root, "cache"))
      end
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "installs a configured parser pack when GrammarManager initializes" do
    root = File.join(Dir.tempdir, "tsm-parser-pack-env-#{Random::Secure.hex(8)}")
    bundle_dir = File.join(root, "bundle")
    cache_dir = File.join(root, "cache")
    library_dir = File.join(bundle_dir, "python")
    library_name = TreeSitterManager::Platform.grammar_library_name("python")
    library_path = File.join(library_dir, library_name)

    begin
      Dir.mkdir_p(library_dir)
      File.write(library_path, "fixture grammar")
      sha256 = Digest::SHA256.hexdigest(File.read(library_path))
      File.write(File.join(bundle_dir, "parser-pack.json"), {
        "version"  => 1,
        "platform" => TreeSitterManager::Platform.artifact_tag,
        "parsers"  => [{"language" => "python", "file" => "python/#{library_name}", "sha256" => sha256}],
      }.to_json)

      ENV[TreeSitterManager::ParserPack::ENVIRONMENT_DIRECTORY] = bundle_dir
      TreeSitterManager::GrammarManager.test_reset(cache_dir)
      TreeSitterManager::GrammarManager.init(cache_dir)
      File.exists?(File.join(cache_dir, "python", library_name)).should be_true
    ensure
      ENV.delete(TreeSitterManager::ParserPack::ENVIRONMENT_DIRECTORY)
      TreeSitterManager::GrammarManager.test_reset
      FileUtils.rm_rf(root) if Dir.exists?(root)
      TreeSitterManager::GrammarLoader.clear_registered_directories_for_test
    end
  end
end
