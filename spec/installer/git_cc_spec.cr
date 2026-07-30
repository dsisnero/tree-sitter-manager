require "../spec_helper"
require "file_utils"

describe TreeSitterManager::Installer::GitCc do
  it "is a concrete installer strategy" do
    TreeSitterManager::Installer::GitCc.new.should be_a(TreeSitterManager::Installer::Base)
  end

  it "clones, compiles, caches, and records a local grammar repository" do
    root = File.join(Dir.tempdir, "tsm-git-cc-#{Random::Secure.hex(8)}")
    repository = File.join(root, "fixture-repository")
    cache_root = File.join(root, "cache")

    begin
      Dir.mkdir_p(File.join(repository, "src"))
      File.write(File.join(repository, "src", "parser.c"), "void *tree_sitter_fixture(void) { return 0; }\n")
      Process.run("git", ["init"], chdir: repository).success?.should be_true
      Process.run("git", ["config", "user.email", "fixture@example.test"], chdir: repository).success?.should be_true
      Process.run("git", ["config", "user.name", "Fixture"], chdir: repository).success?.should be_true
      Process.run("git", ["add", "."], chdir: repository).success?.should be_true
      Process.run("git", ["commit", "-m", "fixture grammar"], chdir: repository).success?.should be_true

      cache = TreeSitterManager::CacheDir.new(cache_root)
      result = TreeSitterManager::Installer::Coordinator.new(
        cache,
        [TreeSitterManager::Installer::GitCc.new(repository_url: repository)]
      ).install("fixture")

      result.success?.should be_true
      cache["fixture"]?.should_not be_nil
      metadata = TreeSitterManager::GrammarMetadataStore.load(cache.language_dir("fixture"))
      metadata.should_not be_nil
      metadata.not_nil!.type.should eq("cc")
      metadata.not_nil!.url.should eq(repository)
      metadata.not_nil!.commit_hash.should_not be_nil
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "generates parser C when a clone does not include it" do
    root = File.join(Dir.tempdir, "tsm-git-cc-generate-#{Random::Secure.hex(8)}")
    repository = File.join(root, "fixture-repository")
    command = File.join(root, "fake-tree-sitter")
    cache_root = File.join(root, "cache")

    begin
      Dir.mkdir_p(repository)
      File.write(File.join(repository, "grammar.js"), "module.exports = grammar({name: 'fixture'});\n")
      Process.run("git", ["init"], chdir: repository).success?.should be_true
      Process.run("git", ["config", "user.email", "fixture@example.test"], chdir: repository).success?.should be_true
      Process.run("git", ["config", "user.name", "Fixture"], chdir: repository).success?.should be_true
      Process.run("git", ["add", "."], chdir: repository).success?.should be_true
      Process.run("git", ["commit", "-m", "fixture grammar"], chdir: repository).success?.should be_true
      File.write(command, "#!/bin/sh\nmkdir -p src\nprintf 'void *tree_sitter_fixture(void) { return 0; }\\n' > src/parser.c\n")
      File.chmod(command, 0o755)

      result = TreeSitterManager::Installer::Coordinator.new(
        TreeSitterManager::CacheDir.new(cache_root),
        [TreeSitterManager::Installer::GitCc.new(repository_url: repository, tree_sitter_command: command)]
      ).install("fixture")

      result.success?.should be_true
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
