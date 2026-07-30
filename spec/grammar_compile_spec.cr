require "./spec_helper"
require "file_utils"

describe TreeSitterManager::GrammarManager, "#compile_sources" do
  it "compiles a C source file into a shared library" do
    tmpdir = File.join(Dir.tempdir, "tsm-cc-test-#{Random.rand(1_000_000)}")
    Dir.mkdir_p(tmpdir)
    src_dir = File.join(tmpdir, "src")
    Dir.mkdir_p(src_dir)

    File.write(File.join(src_dir, "parser.c"), "int tree_sitter_test(void) { return 42; }\n")

    begin
      output_path = File.join(tmpdir, TreeSitterManager::Platform.lib_name("test"))

      ok, err = TreeSitterManager::GrammarManager.compile_sources(tmpdir, "test", output_path)
      ok.should be_true, "compile failed: #{err}"
      File.exists?(output_path).should be_true
    ensure
      FileUtils.rm_rf(tmpdir) if Dir.exists?(tmpdir)
    end
  end

  it "responds to compile_sources" do
    TreeSitterManager::GrammarManager.responds_to?(:compile_sources).should be_true
  end

  it "builds the canonical grammar library filename" do
    extension = TreeSitterManager::Platform.shared_library_extension

    TreeSitterManager::Platform.lib_name("python").should eq("libtree-sitter-python.#{extension}")
    TreeSitterManager::Platform.grammar_library_name("python").should eq("libtree-sitter-python.#{extension}")
  end
end
