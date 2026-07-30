require "../spec_helper"
require "file_utils"

describe TreeSitterManager::Installer::GitTreeSitter do
  it "is a concrete installer strategy" do
    TreeSitterManager::Installer::GitTreeSitter.new.should be_a(TreeSitterManager::Installer::Base)
  end

  it "runs generate then build in an isolated clone workspace" do
    root = File.join(Dir.tempdir, "tsm-git-ts-#{Random::Secure.hex(8)}")
    repository = File.join(root, "fixture-repository")
    command = File.join(root, "fake-tree-sitter")
    log = File.join(root, "commands.log")
    cache_root = File.join(root, "cache")
    extension = TreeSitterManager::Platform.shared_library_extension

    begin
      Dir.mkdir_p(repository)
      File.write(File.join(repository, "grammar.js"), "module.exports = grammar({name: 'fixture'});\n")
      Process.run("git", ["init"], chdir: repository).success?.should be_true
      Process.run("git", ["config", "user.email", "fixture@example.test"], chdir: repository).success?.should be_true
      Process.run("git", ["config", "user.name", "Fixture"], chdir: repository).success?.should be_true
      Process.run("git", ["add", "."], chdir: repository).success?.should be_true
      Process.run("git", ["commit", "-m", "fixture grammar"], chdir: repository).success?.should be_true

      File.write(command, "#!/bin/sh\necho \"$1:$PWD\" >> #{log}\nif [ \"$1\" = build ]; then printf fixture > fixture.#{extension}; fi\n")
      File.chmod(command, 0o755)

      cache = TreeSitterManager::CacheDir.new(cache_root)
      result = TreeSitterManager::Installer::Coordinator.new(
        cache,
        [TreeSitterManager::Installer::GitTreeSitter.new(repository_url: repository, tree_sitter_command: command)]
      ).install("fixture")

      result.success?.should be_true
      File.read(cache["fixture"]?.not_nil!).should eq("fixture")
      metadata = TreeSitterManager::GrammarMetadataStore.load(cache.language_dir("fixture")).not_nil!
      metadata.type.should eq("tree-sitter")
      metadata.url.should eq(repository)
      metadata.commit_hash.should_not be_nil
      commands = File.read(log).lines.map(&.strip)
      commands.size.should eq(2)
      commands[0].starts_with?("generate:").should be_true
      commands[1].starts_with?("build:").should be_true
      commands.each { |entry| entry.should_not contain(repository) }
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
