require "./spec_helper"
require "file_utils"

describe TreeSitterManager::GrammarOperations do
  it "compiles nested C sources instead of silently omitting them" do
    root = File.join(Dir.tempdir, "tsm-operations-#{Random.rand(1_000_000)}")
    src = File.join(root, "src")
    nested = File.join(src, "generated")

    begin
      Dir.mkdir_p(nested)
      File.write(File.join(src, "parser.c"), "int tree_sitter_fixture(void) { return 42; }\n")
      File.write(File.join(nested, "broken.c"), "this is not valid C\n")

      success, error = TreeSitterManager::GrammarOperations.compile_shared_library_async(root, "fixture").receive
      success.should be_false
      error.not_nil!.should contain("Compilation failed")
    ensure
      FileUtils.rm_rf(root) if Dir.exists?(root)
    end
  end
end
