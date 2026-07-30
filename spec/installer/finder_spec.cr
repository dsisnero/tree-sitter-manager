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

  it "finds a query directory recursively when it contains tree-sitter query assets" do
    root = File.join(Dir.tempdir, "tsm-finder-queries-#{Random::Secure.hex(8)}")
    query_directory = File.join(root, "grammar", "queries")

    begin
      Dir.mkdir_p(query_directory)
      File.write(File.join(query_directory, "highlights.scm"), "(identifier) @variable")

      TreeSitterManager::Installer::Finder.new.find_query_directory_async(root).receive.should eq(query_directory)
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "does not treat unrelated scm files as a grammar query directory" do
    root = File.join(Dir.tempdir, "tsm-finder-non-query-scm-#{Random::Secure.hex(8)}")
    source_directory = File.join(root, "grammar", "src")

    begin
      Dir.mkdir_p(source_directory)
      File.write(File.join(source_directory, "grammar.scm"), "module.exports = grammar({})")

      TreeSitterManager::Installer::Finder.new.find_query_directory_async(root).receive.should be_nil
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
