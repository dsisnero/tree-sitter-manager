require "./spec_helper"
require "file_utils"

describe TreeSitterManager::CacheDir do
  it "creates its root and resolves canonical and legacy library layouts" do
    root = File.join(Dir.tempdir, "tsm-cache-dir-#{Random::Secure.hex(8)}")

    begin
      cache = TreeSitterManager::CacheDir.new(root)
      Dir.exists?(root).should be_true

      canonical = File.join(root, "python", TreeSitterManager::Platform.lib_name("python"))
      Dir.mkdir_p(File.dirname(canonical))
      File.write(canonical, "canonical")
      cache["python"]?.should eq(canonical)

      legacy = File.join(root, "tree-sitter-ruby", TreeSitterManager::Platform.lib_name("ruby"))
      Dir.mkdir_p(File.dirname(legacy))
      File.write(legacy, "legacy")
      cache["ruby"]?.should eq(legacy)

      csharp = cache.library_path("csharp")
      csharp.should end_with(TreeSitterManager::Platform.lib_name("c_sharp"))
      Dir.mkdir_p(File.dirname(csharp))
      File.write(csharp, "csharp")
      cache["csharp"]?.should eq(csharp)
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "adds libraries atomically under the canonical language directory" do
    root = File.join(Dir.tempdir, "tsm-cache-add-#{Random::Secure.hex(8)}")
    source = File.join(Dir.tempdir, "tsm-cache-source-#{Random::Secure.hex(8)}.bin")

    begin
      File.write(source, "grammar bytes")
      cache = TreeSitterManager::CacheDir.new(root)

      destination = cache.add_library("python", source)
      destination.should eq(File.join(root, "python", TreeSitterManager::Platform.lib_name("python")))
      File.read(destination).should eq("grammar bytes")
      cache["python"]?.should eq(destination)
    ensure
      File.delete(source) if File.exists?(source)
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "copies missing legacy entries without overwriting current cache entries" do
    root = File.join(Dir.tempdir, "tsm-cache-current-#{Random::Secure.hex(8)}")
    legacy = File.join(Dir.tempdir, "tsm-cache-legacy-#{Random::Secure.hex(8)}")

    begin
      cache = TreeSitterManager::CacheDir.new(root)
      File.write(File.join(root, "current"), "keep")
      Dir.mkdir_p(File.join(legacy, "python"))
      File.write(File.join(legacy, "python", TreeSitterManager::Platform.lib_name("python")), "legacy")
      File.write(File.join(legacy, "current"), "replace")

      cache.migrate_from_legacy(legacy).should eq(["python"])
      File.read(File.join(root, "python", TreeSitterManager::Platform.lib_name("python"))).should eq("legacy")
      File.read(File.join(root, "current")).should eq("keep")
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
      FileUtils.rm_rf(legacy) if Dir.exists?(legacy)
    end
  end

  it "clears grammar libraries while preserving non-library cache data" do
    root = File.join(Dir.tempdir, "tsm-cache-clear-#{Random::Secure.hex(8)}")

    begin
      cache = TreeSitterManager::CacheDir.new(root)
      source = File.join(root, "fixture.bin")
      File.write(source, "grammar")
      grammar = cache.add_library("python", source)
      metadata = File.join(root, "python", "metadata.json")
      File.write(metadata, "{}")

      cache.clear.should eq(1)
      File.exists?(grammar).should be_false
      File.exists?(metadata).should be_true
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end

  it "installs a grammar library, manifest, and optional queries as one parser artifact" do
    root = File.join(Dir.tempdir, "tsm-cache-parser-#{Random::Secure.hex(8)}")
    source = File.join(Dir.tempdir, "tsm-cache-parser-library-#{Random::Secure.hex(8)}.bin")
    queries = File.join(Dir.tempdir, "tsm-cache-parser-queries-#{Random::Secure.hex(8)}")
    manifest = TreeSitterManager::GrammarMetadata.new(language: "scheme", type: "git", commit_hash: "pinned")

    begin
      File.write(source, "grammar bytes")
      Dir.mkdir_p(queries)
      File.write(File.join(queries, "highlights.scm"), "(identifier) @variable")
      File.write(File.join(queries, "locals.scm"), "(definition) @local.scope")

      cache = TreeSitterManager::CacheDir.new(root)
      destination = cache.install_parser("scheme", source, manifest, queries)

      File.read(destination).should eq("grammar bytes")
      TreeSitterManager::GrammarMetadataStore.load(cache.language_dir("scheme")).not_nil!.commit_hash.should eq("pinned")
      File.read(File.join(cache.language_dir("scheme"), "queries", "highlights.scm")).should eq("(identifier) @variable")
      File.read(File.join(cache.language_dir("scheme"), "queries", "locals.scm")).should eq("(definition) @local.scope")
    ensure
      File.delete(source) if File.exists?(source)
      FileUtils.rm_rf(queries) if Dir.exists?(queries)
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
