require "./spec_helper"
require "file_utils"
require "dir"

describe TreeSitterManager::DownloadManager do
  it "has a default cache directory" do
    dir = TreeSitterManager::DownloadManager.default_cache_dir
    dir.should contain("tree-sitter-manager")
    dir.should contain("libs")
  end

  it "creates cache directory on initialization" do
    tmp = File.join(Dir.tempdir, "tsm-test-cache-#{Random.rand}")
    begin
      dm = TreeSitterManager::DownloadManager.new(tmp)
      Dir.exists?(tmp).should be_true
    ensure
      FileUtils.rm_rf(tmp) if Dir.exists?(tmp)
    end
  end

  it "registers cache dir with GrammarLoader" do
    tmp = File.join(Dir.tempdir, "tsm-test-cache-#{Random.rand}")
    begin
      dm = TreeSitterManager::DownloadManager.new(tmp)
      dm.register_with_loader
      dirs = TreeSitterManager::GrammarLoader.grammar_directories
      dirs.should contain(tmp)
    ensure
      FileUtils.rm_rf(tmp) if Dir.exists?(tmp)
      TreeSitterManager::GrammarLoader.clear_registered_directories_for_test
    end
  end

  it "scans cache for installed libraries" do
    tmp = File.join(Dir.tempdir, "tsm-test-cache-#{Random.rand}")
    begin
      Dir.mkdir_p(tmp)
      # Create a fake library file
      File.write(File.join(tmp, "libtree-sitter-python.so"), "fake")
      dm = TreeSitterManager::DownloadManager.new(tmp)
      installed = dm.installed_languages
      installed.should contain("python")
    ensure
      FileUtils.rm_rf(tmp) if Dir.exists?(tmp)
    end
  end

  it "discovers installed libraries in nested cache directories" do
    tmp = File.join(Dir.tempdir, "tsm-test-cache-#{Random.rand}")
    begin
      nested = File.join(tmp, "releases", "python")
      Dir.mkdir_p(nested)
      File.write(File.join(nested, "libtree-sitter-python.so"), "fake")

      TreeSitterManager::DownloadManager.new(tmp).installed_languages.should contain("python")
    ensure
      FileUtils.rm_rf(tmp) if Dir.exists?(tmp)
    end
  end
end
