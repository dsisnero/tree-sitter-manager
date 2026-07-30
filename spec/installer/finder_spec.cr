require "../spec_helper"
require "file_utils"

describe TreeSitterManager::Installer::Finder do
  it "finds canonical grammar libraries recursively" do
    root = File.join(Dir.tempdir, "tsm-finder-#{Random::Secure.hex(8)}")
    language = "python"
    library = File.join(root, "release", "grammars", TreeSitterManager::Platform.lib_name(language))

    begin
      Dir.mkdir_p(File.dirname(library))
      File.write(library, "grammar")

      TreeSitterManager::Installer::Finder.new.find_async(root, language).receive.should eq(library)
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "accepts tree-sitter CLI alternate output names" do
    root = File.join(Dir.tempdir, "tsm-finder-alternate-#{Random::Secure.hex(8)}")
    language = "ruby"
    extension = TreeSitterManager::Platform.shared_library_extension
    library = File.join(root, "build", "parser.#{extension}")

    begin
      Dir.mkdir_p(File.dirname(library))
      File.write(library, "grammar")

      TreeSitterManager::Installer::Finder.new.find_async(root, language).receive.should eq(library)
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "returns nil without walking when cancellation was already requested" do
    root = File.join(Dir.tempdir, "tsm-finder-cancelled-#{Random::Secure.hex(8)}")
    cancelled = Atomic(Bool).new(true)

    begin
      Dir.mkdir_p(root)
      TreeSitterManager::Installer::Finder.new.find_async(root, "python", cancelled).receive.should be_nil
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
