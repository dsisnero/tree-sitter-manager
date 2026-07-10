require "./spec_helper"
require "bubbletea"
require "../src/tree_sitter_manager/tui"
require "../src/tree_sitter_manager/tui_app"

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

  it "cycles theme backwards" do
    model = TreeSitterManager::Tui::Model.new
    original = model.theme_name
    model.cycle_theme_backwards
    model.theme_name.should_not eq(original)
  end

  it "returns language_name for open file" do
    model = TreeSitterManager::Tui::Model.new
    model.update(TreeSitterManager::Tui::OpenFileMsg.new("spec/spec_helper.cr"))
    model.language_name.should eq("crystal")
  end

  it "returns nil language_name when no file open" do
    model = TreeSitterManager::Tui::Model.new
    model.language_name.should be_nil
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

describe TreeSitterManager::Tui::App do
  it "initializes with default state" do
    app = TreeSitterManager::Tui::App.new
    app.model.theme_name.should eq("dracula::dracula")
    app.model.current_file.should be_nil
    app.quitting?.should be_false
    app.help_shown?.should be_false
  end

  it "init returns window size command" do
    app = TreeSitterManager::Tui::App.new
    cmd = app.init
    cmd.should_not be_nil
  end

  it "handles WindowSizeMsg to set viewport dimensions" do
    app = TreeSitterManager::Tui::App.new
    msg = Tea::WindowSizeMsg.new(width: 80, height: 24)
    app.update(msg)
    app.viewport.width.should eq(80)
    app.viewport.height.should eq(20)
  end

  it "quits on 'q' key" do
    app = TreeSitterManager::Tui::App.new
    msg = Tea::KeyPressMsg.new(code: 'q'.ord, text: "q")
    app.update(msg)
    app.quitting?.should be_true
  end

  it "cycles theme forward on 't' key" do
    app = TreeSitterManager::Tui::App.new
    original = app.model.theme_name
    msg = Tea::KeyPressMsg.new(code: 't'.ord, text: "t")
    app.update(msg)
    app.model.theme_name.should_not eq(original)
  end

  it "cycles theme backward on 'T' key" do
    app = TreeSitterManager::Tui::App.new
    original = app.model.theme_name
    msg = Tea::KeyPressMsg.new(code: 'T'.ord, text: "T")
    app.update(msg)
    app.model.theme_name.should_not eq(original)
  end

  it "delegates arrow down to viewport" do
    app = TreeSitterManager::Tui::App.new
    app.update(TreeSitterManager::Tui::OpenFileMsg.new("spec/spec_helper.cr"))
    msg = Tea::KeyPressMsg.new(code: Tea::KeyDown, text: "")
    app.update(msg)
    app.viewport.y_offset.should be > 0
  end

  it "shows help when ? pressed" do
    app = TreeSitterManager::Tui::App.new
    msg = Tea::KeyPressMsg.new(code: '?'.ord, text: "?")
    app.update(msg)
    app.help_shown?.should be_true
  end

  it "toggles help off when ? pressed again" do
    app = TreeSitterManager::Tui::App.new
    msg = Tea::KeyPressMsg.new(code: '?'.ord, text: "?")
    app.update(msg)
    app.update(msg)
    app.help_shown?.should be_false
  end

  it "shows status line with file info when file is open" do
    app = TreeSitterManager::Tui::App.new
    app.model.update(TreeSitterManager::Tui::OpenFileMsg.new("spec/spec_helper.cr"))
    view = app.view
    view.content.should contain("spec_helper.cr")
  end

  it "resizes viewport on WindowSizeMsg with proper header/status/help reservation" do
    app = TreeSitterManager::Tui::App.new
    msg = Tea::WindowSizeMsg.new(width: 120, height: 40)
    app.update(msg)
    app.viewport.width.should eq(120)
    app.viewport.height.should eq(36)
  end

  it "opens file picker on Ctrl+o" do
    app = TreeSitterManager::Tui::App.new
    ctrl_o = Tea::KeyPressMsg.new(code: 'o'.ord, mod: Ultraviolet::ModCtrl)
    app.update(ctrl_o)
    app.picker_active?.should be_true
  end

  it "closes file picker on escape" do
    app = TreeSitterManager::Tui::App.new
    ctrl_o = Tea::KeyPressMsg.new(code: 'o'.ord, mod: Ultraviolet::ModCtrl)
    app.update(ctrl_o)
    app.picker_active?.should be_true

    esc = Tea::KeyPressMsg.new(code: Tea::KeyEscape, text: "")
    app.update(esc)
    app.picker_active?.should be_false
  end

  it "shows theme swatch color" do
    app = TreeSitterManager::Tui::App.new
    swatch = app.model.theme_swatch_color
    swatch.should_not be_nil
    swatch.should match(/^#[0-9a-fA-F]{6}$/)
  end

  it "renders swatch in view" do
    app = TreeSitterManager::Tui::App.new
    view = app.view
    view.content.should contain("●")
  end

  it "jumps to theme by name prefix" do
    model = TreeSitterManager::Tui::Model.new
    result = model.update(TreeSitterManager::Tui::ThemeSearchMsg.new("nord"))
    result.theme_name.should eq("nord::nord")
  end

  it "jumps to first theme matching prefix" do
    model = TreeSitterManager::Tui::Model.new
    result = model.update(TreeSitterManager::Tui::ThemeSearchMsg.new("gru"))
    result.theme_name.should eq("gruvbox::dark")
  end

  it "activates search mode on / key" do
    app = TreeSitterManager::Tui::App.new
    msg = Tea::KeyPressMsg.new(code: '/'.ord, text: "/")
    app.update(msg)
    app.search_active?.should be_true
  end

  it "exits search mode on enter" do
    app = TreeSitterManager::Tui::App.new
    msg = Tea::KeyPressMsg.new(code: '/'.ord, text: "/")
    app.update(msg)
    app.search_active?.should be_true

    enter = Tea::KeyPressMsg.new(code: Tea::KeyEnter, text: "")
    app.update(enter)
    app.search_active?.should be_false
  end

  it "exits search mode on escape" do
    app = TreeSitterManager::Tui::App.new
    msg = Tea::KeyPressMsg.new(code: '/'.ord, text: "/")
    app.update(msg)
    app.search_active?.should be_true

    esc = Tea::KeyPressMsg.new(code: Tea::KeyEscape, text: "")
    app.update(esc)
    app.search_active?.should be_false
  end

  it "shows search input in view when active" do
    app = TreeSitterManager::Tui::App.new
    app.update(Tea::WindowSizeMsg.new(80, 24))
    msg = Tea::KeyPressMsg.new(code: '/'.ord, text: "/")
    app.update(msg)
    view = app.view
    view.content.should contain("/")
  end

  it "jumps to theme during search" do
    app = TreeSitterManager::Tui::App.new
    app.update(Tea::WindowSizeMsg.new(80, 24))
    msg = Tea::KeyPressMsg.new(code: '/'.ord, text: "/")
    app.update(msg)

    key_n = Tea::KeyPressMsg.new(code: 'n'.ord, text: "n")
    app.update(key_n)
    app.model.theme_name.should eq("neon::dark")

    key_o = Tea::KeyPressMsg.new(code: 'o'.ord, text: "o")
    app.update(key_o)
    app.model.theme_name.should eq("nord::nord")
  end

  it "help bar shows quit in short help" do
    app = TreeSitterManager::Tui::App.new
    app.update(Tea::WindowSizeMsg.new(120, 40))
    view = app.view
    view.content.should contain("q")
    view.content.should contain("quit")
  end

  it "help bar shows theme search binding" do
    app = TreeSitterManager::Tui::App.new
    app.update(Tea::WindowSizeMsg.new(120, 40))
    view = app.view
    view.content.should contain("/")
    view.content.should contain("search theme")
  end

  it "full help shows all bindings" do
    app = TreeSitterManager::Tui::App.new
    app.update(Tea::WindowSizeMsg.new(120, 40))
    key_q = Tea::KeyPressMsg.new(code: '?'.ord, text: "?")
    app.update(key_q)
    view = app.view
    view.content.should contain("search theme")
    view.content.should contain("cycle theme")
    view.content.should contain("scroll page")
  end

  it "creates InstallDoneMsg with success" do
    msg = TreeSitterManager::Tui::InstallDoneMsg.new("python", true)
    msg.language.should eq("python")
    msg.success.should be_true
    msg.error.should be_nil
    msg.should be_a(Tea::Msg)
  end

  it "creates InstallDoneMsg with failure" do
    msg = TreeSitterManager::Tui::InstallDoneMsg.new("rust", false, "compilation error")
    msg.language.should eq("rust")
    msg.success.should be_false
    msg.error.should eq("compilation error")
  end

  it "queues file when opening during install" do
    app = TreeSitterManager::Tui::App.new
    app.update(Tea::WindowSizeMsg.new(80, 24))
    # Set installing state manually (simulates ongoing install)
    app.installing = true
    # Send OpenFileMsg while installing
    app.update(TreeSitterManager::Tui::OpenFileMsg.new("spec/spec_helper.cr"))
    # File should not be opened yet (pending)
    app.model.current_file.should be_nil
  end

  it "shows file picker view when active" do
    app = TreeSitterManager::Tui::App.new
    ctrl_o = Tea::KeyPressMsg.new(code: 'o'.ord, mod: Ultraviolet::ModCtrl)
    app.update(ctrl_o)

    fp = app.filepicker
    fp.should_not be_nil
    fp = fp.as(Bubbles::Filepicker::Model)

    entries = Dir.children(".").map do |name|
      info = File.info(File.join(".", name), follow_symlinks: false)
      Bubbles::Filepicker::Entry.new(name, info)
    end
    read_dir = Bubbles::Filepicker::ReadDirMsg.new(fp.id, entries)
    app.update(read_dir)

    view = app.view
    view.content.should contain("src")
  end
end
