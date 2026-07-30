require "../spec_helper"
require "file_utils"

private class SuccessfulFixtureInstaller < TreeSitterManager::Installer::Base
  getter temporary_directory : String?

  def download(language : String, temporary_directory : String) : TreeSitterManager::BoolResult
    @temporary_directory = temporary_directory
    extension = TreeSitterManager::Platform.shared_library_extension
    File.write(File.join(temporary_directory, "#{language}.#{extension}"), "fixture grammar")
    TreeSitterManager::BoolResult.success
  end

  def create_manifest(language : String, temporary_directory : String) : TreeSitterManager::GrammarMetadata
    TreeSitterManager::GrammarMetadata.new(language: language, type: "fixture", package_name: "fixture")
  end
end

private class FailingFixtureInstaller < TreeSitterManager::Installer::Base
  def download(language : String, temporary_directory : String) : TreeSitterManager::BoolResult
    TreeSitterManager::BoolResult.failure("fixture failure")
  end

  def find_lib_file(language : String, temporary_directory : String) : String?
    nil
  end

  def create_manifest(language : String, temporary_directory : String) : TreeSitterManager::GrammarMetadata
    TreeSitterManager::GrammarMetadata.new
  end
end

private class MethodFixtureInstaller < TreeSitterManager::Installer::Base
  def initialize(@method : Symbol, @content : String)
  end

  def installation_method : Symbol
    @method
  end

  def download(language : String, temporary_directory : String) : TreeSitterManager::BoolResult
    extension = TreeSitterManager::Platform.shared_library_extension
    File.write(File.join(temporary_directory, "#{language}.#{extension}"), @content)
    TreeSitterManager::BoolResult.success
  end

  def create_manifest(language : String, temporary_directory : String) : TreeSitterManager::GrammarMetadata
    TreeSitterManager::GrammarMetadata.new(language: language, type: @method.to_s, package_name: "fixture")
  end
end

describe TreeSitterManager::Installer::Coordinator do
  it "runs installers concurrently and atomically installs the first successful artifact with its manifest" do
    root = File.join(Dir.tempdir, "tsm-installer-#{Random::Secure.hex(8)}")

    begin
      cache = TreeSitterManager::CacheDir.new(root)
      successful = SuccessfulFixtureInstaller.new
      coordinator = TreeSitterManager::Installer::Coordinator.new(cache, [FailingFixtureInstaller.new, successful])

      result = coordinator.install("python")

      result.success?.should be_true
      library = cache["python"]?
      library.should_not be_nil
      File.read(library.not_nil!).should eq("fixture grammar")
      TreeSitterManager::GrammarMetadataStore.load(cache.language_dir("python")).try(&.type).should eq("fixture")
      Dir.exists?(successful.temporary_directory.not_nil!).should be_false
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "commits the preferred successful strategy instead of the first candidate received" do
    root = File.join(Dir.tempdir, "tsm-installer-preferred-#{Random::Secure.hex(8)}")

    begin
      cache = TreeSitterManager::CacheDir.new(root)
      result = TreeSitterManager::Installer::Coordinator.new(
        cache,
        [MethodFixtureInstaller.new(:cc, "cc"), MethodFixtureInstaller.new(:npm, "npm")]
      ).install("python", :npm)

      result.success?.should be_true
      File.read(cache["python"]?.not_nil!).should eq("npm")
      TreeSitterManager::GrammarMetadataStore.load(cache.language_dir("python")).not_nil!.type.should eq("npm")
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
