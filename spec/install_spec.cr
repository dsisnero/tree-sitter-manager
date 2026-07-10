require "./spec_helper"
require "file_utils"

describe "Grammar install pipeline" do
  it "installs crystal grammar via cc and loads it" do
    mgr = TreeSitterManager::GrammarManager.instance
    mgr.class.init

    # Sync install with result
    result = mgr.ensure_grammar_with_result("crystal", 120_000)
    result.success?.should be_true, "Install failed: #{result.error}"

    # Verify cache
    cache = mgr.cache_dir
    cache.should_not be_nil
    crystal_dir = File.join(cache.not_nil!, "crystal")
    Dir.exists?(crystal_dir).should be_true, "No crystal dir in #{cache}"

    # Verify the .so exists
    ext = TreeSitterManager::Platform.shared_library_extension
    lib_path = File.join(crystal_dir, "libtree-sitter-crystal.#{ext}")
    File.exists?(lib_path).should be_true, "No library at #{lib_path}"

    # Try loading
    lang = TreeSitterManager::GrammarLoader.load_language("crystal")
    lang.should_not be_nil
  end
end
