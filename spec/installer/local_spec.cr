require "../spec_helper"
require "file_utils"

describe TreeSitterManager::Installer::Local do
  it "is a concrete installer strategy" do
    TreeSitterManager::Installer::Local.new("/tmp").should be_a(TreeSitterManager::Installer::Base)
  end

  it "builds an isolated copy without mutating the local grammar source" do
    root = File.join(Dir.tempdir, "tsm-local-#{Random::Secure.hex(8)}")
    source = File.join(root, "source")
    command = File.join(root, "fake-tree-sitter")
    extension = TreeSitterManager::Platform.shared_library_extension

    begin
      Dir.mkdir_p(source)
      File.write(File.join(source, "grammar.js"), "module.exports = grammar({name: 'fixture'});\n")
      File.write(command, "#!/bin/sh\nif [ \"$1\" = build ]; then printf fixture > fixture.#{extension}; fi\n")
      File.chmod(command, 0o755)
      cache = TreeSitterManager::CacheDir.new(File.join(root, "cache"))

      result = TreeSitterManager::Installer::Coordinator.new(
        cache,
        [TreeSitterManager::Installer::Local.new(source, tree_sitter_command: command)]
      ).install("fixture")

      result.success?.should be_true
      File.read(cache["fixture"]?.not_nil!).should eq("fixture")
      File.exists?(File.join(source, "fixture.#{extension}")).should be_false
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
