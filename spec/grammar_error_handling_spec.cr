require "./spec_helper"
require "../src/tree_sitter_manager/grammar_manager"

describe TreeSitterManager::GrammarManager do
  describe "compile_sources" do
    it "returns stderr on compilation failure" do
      tmpdir = File.join(Dir.tempdir, "tsm-err-#{Random.rand(1_000_000)}")
      Dir.mkdir_p(tmpdir)
      src_dir = File.join(tmpdir, "src")
      Dir.mkdir_p(src_dir)

      # Write broken C code to trigger compiler error
      File.write(File.join(src_dir, "parser.c"), "this is not valid C code\n")

      begin
        ok, err = TreeSitterManager::GrammarManager.compile_sources(tmpdir, "broken", "/dev/null")
        ok.should be_false
        err.should_not be_empty
      ensure
        FileUtils.rm_rf(tmpdir) if Dir.exists?(tmpdir)
      end
    end

    it "returns false when parser.c is missing" do
      tmpdir = File.join(Dir.tempdir, "tsm-missing-#{Random.rand(1_000_000)}")
      Dir.mkdir_p(tmpdir)
      Dir.mkdir_p(File.join(tmpdir, "src"))

      begin
        ok, err = TreeSitterManager::GrammarManager.compile_sources(tmpdir, "missing", "/dev/null")
        ok.should be_false
        err.should contain("parser.c not found")
      ensure
        FileUtils.rm_rf(tmpdir) if Dir.exists?(tmpdir)
      end
    end
  end

  describe "BoolResult" do
    it "creates failure with details" do
      result = TreeSitterManager::BoolResult.failure(
        "cc compile failed: syntax error",
        {"language" => "rust", "compiler" => "cc"}
      )
      result.success?.should be_false
      result.error.should_not be_nil
      result.error.not_nil!.should contain("syntax error")
      result.details["language"].should eq("rust")
      result.details["compiler"].should eq("cc")
    end

    it "creates success result" do
      result = TreeSitterManager::BoolResult.success
      result.success?.should be_true
      result.error.should be_nil
    end
  end
end
