require "../spec_helper"
require "file_utils"

describe TreeSitterManager::Installer::Npm do
  it "installs into its temporary directory and caches the discovered library" do
    root = File.join(Dir.tempdir, "tsm-npm-#{Random::Secure.hex(8)}")
    command = File.join(root, "fake-npm")
    cache_root = File.join(root, "cache")
    extension = TreeSitterManager::Platform.shared_library_extension

    begin
      Dir.mkdir_p(root)
      File.write(command, "#!/bin/sh\nmkdir -p node_modules/fixture\nprintf fixture > node_modules/fixture/parser.#{extension}\n")
      File.chmod(command, 0o755)

      cache = TreeSitterManager::CacheDir.new(cache_root)
      result = TreeSitterManager::Installer::Coordinator.new(
        cache,
        [TreeSitterManager::Installer::Npm.new(package_name: "fixture", npm_command: command)]
      ).install("fixture")

      result.success?.should be_true
      File.read(cache["fixture"]?.not_nil!).should eq("fixture")
      TreeSitterManager::GrammarMetadataStore.load(cache.language_dir("fixture")).not_nil!.type.should eq("npm")
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
