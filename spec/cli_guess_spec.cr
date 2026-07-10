require "./spec_helper"

describe "CLI language guessing" do
  describe ".guess_language" do
    it "returns python for .py extension" do
      TreeSitterManager::CLI.guess_language("test.py").should eq("python")
    end

    it "returns nil for unknown extension without content" do
      TreeSitterManager::CLI.guess_language("test.xyzzy").should be_nil
    end

    it "falls back to content detection for files without recognized extension" do
      # File with no extension but bash shebang
      # Simulate via content parameter
      TreeSitterManager::CLI.guess_language("script", content: "#!/bin/bash\necho hi").should eq("bash")
    end

    it "falls back to content detection for extension-less files" do
      TreeSitterManager::CLI.guess_language("Makefile", content: "all:\n\tgcc main.c").should eq("make")
    end

    it "uses content detection for shebang files" do
      TreeSitterManager::CLI.guess_language("run", content: "#!/usr/bin/env python3\nprint('hi')").should eq("python")
    end

    it "returns nil when both extension and content detection fail" do
      TreeSitterManager::CLI.guess_language("unknown_file", content: "blah blah").should be_nil
    end
  end
end
