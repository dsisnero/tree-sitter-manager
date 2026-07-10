require "./spec_helper"

describe TreeSitterManager::Tui::Model do
  it "initializes with default theme and empty file" do
    model = TreeSitterManager::Tui::Model.new
    model.theme_name.should eq("dracula::dracula")
    model.current_file.should be_nil
    model.highlighted_content.should eq("")
  end

  it "cycles theme on cycle message" do
    model = TreeSitterManager::Tui::Model.new
    result = model.update(TreeSitterManager::Tui::CycleThemeMsg.new)
    result.theme_name.should_not eq("dracula::dracula")
    TreeSitterManager::Themes::THEMES.should contain(result.theme_name)
  end

  it "highlights file on open message" do
    model = TreeSitterManager::Tui::Model.new
    result = model.update(TreeSitterManager::Tui::OpenFileMsg.new("spec/spec_helper.cr"))
    result.current_file.should eq("spec/spec_helper.cr")
    result.highlighted_content.should_not be_empty
  end

  it "sets quitting on quit message" do
    model = TreeSitterManager::Tui::Model.new
    result = model.update(TreeSitterManager::Tui::QuitMsg.new)
    result.quitting?.should be_true
  end

  it "returns self unchanged on unhandled message" do
    model = TreeSitterManager::Tui::Model.new
    result = model.update("unknown")
    result.should be_a(TreeSitterManager::Tui::Model)
  end
end
