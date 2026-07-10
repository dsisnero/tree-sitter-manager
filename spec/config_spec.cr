require "./spec_helper"
require "../src/tree_sitter_manager/config"

describe TreeSitterManager::AppConfig do
  it "uses defaults when no config file exists" do
    config = TreeSitterManager::Config.load
    config.theme.should eq("dracula::dracula")
    config.format.should eq("terminal")
    config.auto_install.should be_true
  end

  it "uses hardcoded defaults in AppConfig struct" do
    config = TreeSitterManager::AppConfig.new
    config.theme.should eq("dracula::dracula")
    config.format.should eq("terminal")
    config.auto_install.should be_true
  end

  it "allows overriding all fields in AppConfig" do
    config = TreeSitterManager::AppConfig.new(
      theme: "nord::nord",
      format: "html",
      cache_dir: "/tmp/grammars",
      auto_install: false,
    )
    config.theme.should eq("nord::nord")
    config.format.should eq("html")
    config.cache_dir.should eq("/tmp/grammars")
    config.auto_install.should be_false
  end

  it "loads from config file when present" do
    Dir.mkdir_p("/tmp/tsm-config-test")
    config_path = "/tmp/tsm-config-test/config.toml"
    File.write(config_path, <<-TOML)
      theme = "github::light"
      format = "html"
      auto_install = false
    TOML

    config = TreeSitterManager::Config.from_file(config_path)
    config.theme.should eq("github::light")
    config.format.should eq("html")
    config.auto_install.should be_false
  ensure
    FileUtils.rm_rf("/tmp/tsm-config-test") if Dir.exists?("/tmp/tsm-config-test")
  end

  it "returns defaults for missing config file" do
    config = TreeSitterManager::Config.from_file("/nonexistent/config.toml")
    config.theme.should eq("dracula::dracula")
    config.format.should eq("terminal")
    config.auto_install.should be_true
  end

  it "falls back to defaults for partial config" do
    Dir.mkdir_p("/tmp/tsm-config-partial")
    config_path = "/tmp/tsm-config-partial/config.toml"
    File.write(config_path, <<-TOML)
      theme = "monokai::monokai"
    TOML

    config = TreeSitterManager::Config.from_file(config_path)
    config.theme.should eq("monokai::monokai")
    config.format.should eq("terminal")
    config.auto_install.should be_true
  ensure
    FileUtils.rm_rf("/tmp/tsm-config-partial") if Dir.exists?("/tmp/tsm-config-partial")
  end

  it "parses auto_install correctly when false" do
    Dir.mkdir_p("/tmp/tsm-config-bool")
    config_path = "/tmp/tsm-config-bool/config.toml"
    File.write(config_path, "auto_install = false\n")
    config = TreeSitterManager::Config.from_file(config_path)
    config.auto_install.should be_false
  ensure
    FileUtils.rm_rf("/tmp/tsm-config-bool") if Dir.exists?("/tmp/tsm-config-bool")
  end
end
