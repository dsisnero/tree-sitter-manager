require "../spec_helper"
require "file_utils"

describe TreeSitterManager::VersionChecker::Git do
  it "compares an installed commit with a repository head without grammar metadata" do
    root = File.join(Dir.tempdir, "tsm-version-git-#{Random::Secure.hex(8)}")

    begin
      Dir.mkdir_p(root)
      Process.run("git", ["init"], chdir: root).success?.should be_true
      Process.run("git", ["config", "user.email", "fixture@example.test"], chdir: root).success?.should be_true
      Process.run("git", ["config", "user.name", "Fixture"], chdir: root).success?.should be_true
      File.write(File.join(root, "fixture"), "one")
      Process.run("git", ["add", "."], chdir: root).success?.should be_true
      Process.run("git", ["commit", "-m", "create fixture commit"], chdir: root).success?.should be_true
      installed = IO::Memory.new
      Process.run("git", ["rev-parse", "HEAD"], chdir: root, output: installed).success?.should be_true
      File.write(File.join(root, "fixture"), "two")
      Process.run("git", ["commit", "-am", "update fixture commit"], chdir: root).success?.should be_true

      checker = TreeSitterManager::VersionChecker::Git.new
      checker.needs_update?(root, installed.to_s.strip).value.should be_true
      latest = IO::Memory.new
      Process.run("git", ["rev-parse", "HEAD"], chdir: root, output: latest).success?.should be_true
      checker.needs_update?(root, latest.to_s.strip).value.should be_false
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
