require "../spec_helper"
require "file_utils"

describe TreeSitterManager::VersionChecker::Git do
  it "compares a pinned revision with its configured remote ref" do
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
      Process.run("git", ["branch", "stable"], chdir: root).success?.should be_true
      File.write(File.join(root, "fixture"), "two")
      Process.run("git", ["commit", "-am", "update fixture commit"], chdir: root).success?.should be_true

      checker = TreeSitterManager::VersionChecker::Git.new
      default_branch = IO::Memory.new
      Process.run("git", ["symbolic-ref", "--short", "HEAD"], chdir: root, output: default_branch).success?.should be_true
      checker.default_ref_for(root).value.should eq("refs/heads/#{default_branch.to_s.strip}")
      stable = TreeSitterManager::VersionChecker::GitVersion.new(root, installed.to_s.strip, "refs/heads/stable")
      checker.needs_update?(stable).value.should be_false

      Process.run("git", ["branch", "-f", "stable", "HEAD"], chdir: root).success?.should be_true
      checker.needs_update?(stable).value.should be_true

      latest = IO::Memory.new
      Process.run("git", ["rev-parse", "stable"], chdir: root, output: latest).success?.should be_true
      checker.needs_update?(TreeSitterManager::VersionChecker::GitVersion.new(root, latest.to_s.strip, "refs/heads/stable")).value.should be_false
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
