require "./spec_helper"
require "file_utils"

describe TreeSitterManager::DirectoryWalker do
  it "returns immediate children without traversing descendants" do
    root = File.join(Dir.tempdir, "tsm-directory-walker-#{Random.rand(1_000_000)}")
    nested = File.join(root, "directory", "nested.txt")

    begin
      Dir.mkdir_p(File.dirname(nested))
      File.write(File.join(root, "root.txt"), "root")
      File.write(nested, "nested")

      children = TreeSitterManager::DirectoryWalker.children(root)
      children.should contain("root.txt")
      children.should contain("directory")
      children.should_not contain("nested.txt")
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "finds files with a suffix recursively" do
    root = File.join(Dir.tempdir, "tsm-directory-walker-files-#{Random.rand(1_000_000)}")
    matching = File.join(root, "nested", "parser.c")

    begin
      Dir.mkdir_p(File.dirname(matching))
      File.write(matching, "parser")
      File.write(File.join(root, "ignored.txt"), "ignored")

      TreeSitterManager::DirectoryWalker.files(root, ".c").should eq([matching])
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "finds every file recursively when no suffix is supplied" do
    root = File.join(Dir.tempdir, "tsm-directory-walker-all-#{Random.rand(1_000_000)}")
    nested = File.join(root, "nested", "parser.c")
    root_file = File.join(root, "README")

    begin
      Dir.mkdir_p(File.dirname(nested))
      File.write(nested, "parser")
      File.write(root_file, "readme")

      TreeSitterManager::DirectoryWalker.files(root).should eq([root_file, nested].sort)
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
