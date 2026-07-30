require "../spec_helper"
require "file_utils"

describe TreeSitterManager::VersionChecker::Npm do
  it "compares an installed version with the latest package version without grammar metadata" do
    root = File.join(Dir.tempdir, "tsm-version-npm-#{Random::Secure.hex(8)}")
    command = File.join(root, "fake-npm")

    begin
      Dir.mkdir_p(root)
      File.write(command, "#!/bin/sh\nprintf '2.0.0\\n'\n")
      File.chmod(command, 0o755)

      checker = TreeSitterManager::VersionChecker::Npm.new(npm_command: command)
      checker.needs_update?(TreeSitterManager::VersionChecker::NpmVersion.new("fixture-package", "1.0.0")).value.should be_true
      checker.needs_update?(TreeSitterManager::VersionChecker::NpmVersion.new("fixture-package", "2.0.0")).value.should be_false
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
