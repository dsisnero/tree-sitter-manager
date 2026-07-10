require "./spec_helper"

describe TreeSitterManager::LanguageDetection do
  describe ".detect_from_content" do
    it "detects bash from shebang" do
      TreeSitterManager::LanguageDetection.detect_from_content("#!/bin/bash\necho hi").should eq("bash")
    end

    it "detects python from shebang" do
      TreeSitterManager::LanguageDetection.detect_from_content("#!/usr/bin/env python3\nprint('hi')").should eq("python")
    end

    it "detects ruby from shebang" do
      TreeSitterManager::LanguageDetection.detect_from_content("#!/usr/bin/ruby\nputs 'hi'").should eq("ruby")
    end

    it "detects node from shebang" do
      TreeSitterManager::LanguageDetection.detect_from_content("#!/usr/bin/env node\nconsole.log('hi')").should eq("javascript")
    end

    it "returns nil for unrecognized content" do
      TreeSitterManager::LanguageDetection.detect_from_content("hello world").should be_nil
    end

    it "returns nil for empty content" do
      TreeSitterManager::LanguageDetection.detect_from_content("").should be_nil
    end

    it "detects python from vim modeline" do
      content = "# vim: set filetype=python:\nprint('hi')"
      TreeSitterManager::LanguageDetection.detect_from_content(content).should eq("python")
    end

    it "detects language from emacs file variable" do
      content = "# -*- mode: ruby -*-\nputs 'hi'"
      TreeSitterManager::LanguageDetection.detect_from_content(content).should eq("ruby")
    end
  end

  describe ".resolve" do
    it "returns language for unambiguous extension" do
      lang = TreeSitterManager::LanguageDetection.resolve("py", "print('hi')")
      lang.should eq("python")
    end

    it "returns nil for unknown extension without content detection" do
      lang = TreeSitterManager::LanguageDetection.resolve("xyzzy", "some content")
      lang.should be_nil
    end

    it "resolves ambiguous extension with vim modeline content match" do
      TreeSitterManager::LanguageRegistry.register_ambiguous_extension("m", "objc")
      TreeSitterManager::LanguageRegistry.register_ambiguous_extension("m", "matlab")
      lang = TreeSitterManager::LanguageDetection.resolve("m", "/* vim: set ft=objc: */\nint main() { return 0; }")
      lang.should eq("objc")
    end

    it "returns primary language for ambiguous extension without content match" do
      TreeSitterManager::LanguageRegistry.register_ambiguous_extension("m", "objc")
      TreeSitterManager::LanguageRegistry.register_ambiguous_extension("m", "matlab")
      lang = TreeSitterManager::LanguageDetection.resolve("m", "some content without markers")
      lang.should_not be_nil
    end
  end
end
