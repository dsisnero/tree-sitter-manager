require "./spec_helper"

describe TreeSitterManager::CLI do
  describe "command parsing" do
    it "parses highlight command with theme" do
      command = TreeSitterManager::CLI::Highlight.parse(["--theme", "dracula", "test.py"])
      command.should_not be_a(TreeSitterManager::CLI::Highlight::Help)
      cmd = command.as(TreeSitterManager::CLI::Highlight)
      cmd.file.should eq("test.py")
      cmd.theme.should eq("dracula")
    end

    it "parses highlight with explicit language" do
      command = TreeSitterManager::CLI::Highlight.parse(["--lang", "python", "--theme", "nord", "script.py"])
      command.should_not be_a(TreeSitterManager::CLI::Highlight::Help)
      cmd = command.as(TreeSitterManager::CLI::Highlight)
      cmd.file.should eq("script.py")
      cmd.lang.should eq("python")
      cmd.theme.should eq("nord")
    end

    it "parses highlight with format option" do
      command = TreeSitterManager::CLI::Highlight.parse(["--format", "html", "test.py"])
      command.should_not be_a(TreeSitterManager::CLI::Highlight::Help)
      cmd = command.as(TreeSitterManager::CLI::Highlight)
      cmd.format.should eq("html")
    end

    it "defaults to empty format and theme (resolved from config at run time)" do
      command = TreeSitterManager::CLI::Highlight.parse(["test.py"])
      command.should_not be_a(TreeSitterManager::CLI::Highlight::Help)
      cmd = command.as(TreeSitterManager::CLI::Highlight)
      cmd.format.should eq("")
      cmd.theme.should eq("")
    end

    it "parses themes command" do
      command = TreeSitterManager::CLI::Themes.parse([] of String)
      command.should_not be_a(TreeSitterManager::CLI::Themes::Help)
    end

    it "parses languages command" do
      command = TreeSitterManager::CLI::Languages.parse([] of String)
      command.should_not be_a(TreeSitterManager::CLI::Languages::Help)
    end

    it "parses queries command" do
      command = TreeSitterManager::CLI::Queries.parse(["python"])
      command.should_not be_a(TreeSitterManager::CLI::Queries::Help)
      cmd = command.as(TreeSitterManager::CLI::Queries)
      cmd.language_name.should eq("python")
    end

    it "shows help text" do
      help = TreeSitterManager::CLI::Main.help
      help.should contain("Usage")
      help.should contain("highlight")
      help.should contain("themes")
      help.should contain("languages")
      help.should contain("queries")
      help.should contain("stats")
      help.should contain("groups")
      help.should contain("version")
      help.should contain("doctor")
    end
  end

  describe ".guess_language" do
    it "guesses language from file extension" do
      TreeSitterManager::CLI.guess_language("test.py").should eq("python")
      TreeSitterManager::CLI.guess_language("test.rs").should eq("rust")
      TreeSitterManager::CLI.guess_language("test.go").should eq("go")
      TreeSitterManager::CLI.guess_language("test.js").should eq("javascript")
      TreeSitterManager::CLI.guess_language("test.ts").should eq("typescript")
      TreeSitterManager::CLI.guess_language("test.rb").should eq("ruby")
      TreeSitterManager::CLI.guess_language("test.json").should eq("json")
      TreeSitterManager::CLI.guess_language("test.yaml").should eq("yaml")
      TreeSitterManager::CLI.guess_language("test.yml").should eq("yaml")
      TreeSitterManager::CLI.guess_language("test.md").should eq("markdown")
      TreeSitterManager::CLI.guess_language("test.sh").should eq("bash")
      TreeSitterManager::CLI.guess_language("test.html").should eq("html")
      TreeSitterManager::CLI.guess_language("test.css").should eq("css")
      TreeSitterManager::CLI.guess_language("test.c").should eq("c")
      TreeSitterManager::CLI.guess_language("test.cpp").should eq("cpp")
      TreeSitterManager::CLI.guess_language("test.java").should eq("java")
      TreeSitterManager::CLI.guess_language("test.cr").should eq("crystal")
    end

    it "returns nil for unknown extensions" do
      TreeSitterManager::CLI.guess_language("test.unknownext").should be_nil
    end
  end

  describe "run commands" do
    it "runs themes command without error" do
      command = TreeSitterManager::CLI::Themes.parse([] of String)
      command.should_not be_a(TreeSitterManager::CLI::Themes::Help)
      cmd = command.as(TreeSitterManager::CLI::Themes)
      output = cmd.run
      output.should contain("dracula")
      output.should contain("nord")
    end

    it "runs languages command without error" do
      command = TreeSitterManager::CLI::Languages.parse([] of String)
      command.should_not be_a(TreeSitterManager::CLI::Languages::Help)
      cmd = command.as(TreeSitterManager::CLI::Languages)
      output = cmd.run
      output.should contain("python")
      output.should contain("rust")
    end

    it "runs queries command without error" do
      command = TreeSitterManager::CLI::Queries.parse(["python"])
      command.should_not be_a(TreeSitterManager::CLI::Queries::Help)
      cmd = command.as(TreeSitterManager::CLI::Queries)
      output = cmd.run
      output.should contain("Highlights")
      output.should contain("function")
    end

    it "runs highlight with error for missing file" do
      command = TreeSitterManager::CLI::Highlight.parse(["--lang", "python", "/nonexistent/file.py"])
      command.should_not be_a(TreeSitterManager::CLI::Highlight::Help)
      cmd = command.as(TreeSitterManager::CLI::Highlight)
      output = cmd.run
      output.should contain("Error")
    end

    it "shows help for Main" do
      help = TreeSitterManager::CLI::Main.help
      help.should contain("Usage")
      help.should contain("highlight")
      help.should contain("themes")
      help.should contain("languages")
      help.should contain("queries")
      help.should contain("stats")
      help.should contain("groups")
      help.should contain("version")
      help.should contain("doctor")
    end
    it "parses stats command" do
      command = TreeSitterManager::CLI::Stats.parse([] of String)
      command.should_not be_a(TreeSitterManager::CLI::Stats::Help)
    end

    it "runs stats command with counts" do
      command = TreeSitterManager::CLI::Stats.parse([] of String)
      command.should_not be_a(TreeSitterManager::CLI::Stats::Help)
      cmd = command.as(TreeSitterManager::CLI::Stats)
      output = cmd.run
      output.should contain("Languages")
      output.should contain("Themes")
      output.should contain("Extensions")
      output.should contain("Queries")
    end

    it "parses groups command" do
      command = TreeSitterManager::CLI::Groups.parse([] of String)
      command.should_not be_a(TreeSitterManager::CLI::Groups::Help)
    end

    it "runs groups command listing all groups" do
      command = TreeSitterManager::CLI::Groups.parse([] of String)
      command.should_not be_a(TreeSitterManager::CLI::Groups::Help)
      cmd = command.as(TreeSitterManager::CLI::Groups)
      output = cmd.run
      output.should contain("scripting")
      output.should contain("systems")
      output.should contain("web")
      output.should contain("data")
    end

    it "runs groups command with specific group name" do
      command = TreeSitterManager::CLI::Groups.parse(["scripting"])
      command.should_not be_a(TreeSitterManager::CLI::Groups::Help)
      cmd = command.as(TreeSitterManager::CLI::Groups)
      output = cmd.run
      output.should contain("python")
      output.should contain("ruby")
      output.should contain("javascript")
    end

    it "runs groups command with unknown group" do
      command = TreeSitterManager::CLI::Groups.parse(["nonexistent"])
      command.should_not be_a(TreeSitterManager::CLI::Groups::Help)
      cmd = command.as(TreeSitterManager::CLI::Groups)
      output = cmd.run
      output.should contain("Unknown group")
      output.should contain("Available groups")
    end

    it "parses version command" do
      command = TreeSitterManager::CLI::Version.parse([] of String)
      command.should_not be_a(TreeSitterManager::CLI::Version::Help)
    end

    it "runs version command" do
      command = TreeSitterManager::CLI::Version.parse([] of String)
      command.should_not be_a(TreeSitterManager::CLI::Version::Help)
      cmd = command.as(TreeSitterManager::CLI::Version)
      output = cmd.run
      output.should match(/^\d+\.\d+\.\d+/)
    end

    it "parses doctor command" do
      command = TreeSitterManager::CLI::Doctor.parse([] of String)
      command.should_not be_a(TreeSitterManager::CLI::Doctor::Help)
    end

    it "runs doctor command without error" do
      command = TreeSitterManager::CLI::Doctor.parse([] of String)
      command.should_not be_a(TreeSitterManager::CLI::Doctor::Help)
      cmd = command.as(TreeSitterManager::CLI::Doctor)
      output = cmd.run
      output.should contain("tree-sitter-manager doctor")
      output.should contain("Query files")
      output.should contain("Language registry")
    end

    it "shows all 60+ theme names from THEMES list" do
      command = TreeSitterManager::CLI::Main.parse(["themes"])
      command.should be_a(TreeSitterManager::CLI::Themes)
      output = command.as(TreeSitterManager::CLI::Themes).run
      output.should contain("tokyo::storm")
      output.should contain("catppuccin::mocha")
      output.should contain("gruvbox::dark")
      output.should contain("solarized::light")
      output.should contain("monokai::pro")
    end

    describe "completions" do
      it "parses completions command" do
        command = TreeSitterManager::CLI::Main.parse(["completions", "bash"])
        command.should_not be_a(TreeSitterManager::CLI::Completions::Help)
      end

      it "generates bash completion script" do
        cmd = TreeSitterManager::CLI::Main.parse(["completions", "bash"])
        output = cmd.as(TreeSitterManager::CLI::Completions).run
        output.should contain("# tree-sitter-manager bash completion")
        output.should contain("complete -F _tree_sitter_manager tree-sitter-manager")
      end

      it "generates zsh completion script" do
        cmd = TreeSitterManager::CLI::Main.parse(["completions", "zsh"])
        output = cmd.as(TreeSitterManager::CLI::Completions).run
        output.should contain("# tree-sitter-manager zsh completion")
        output.should contain("compdef _tree_sitter_manager tree-sitter-manager")
      end

      it "generates fish completion script" do
        cmd = TreeSitterManager::CLI::Main.parse(["completions", "fish"])
        output = cmd.as(TreeSitterManager::CLI::Completions).run
        output.should contain("# tree-sitter-manager fish completion")
        output.should contain("complete -c tree-sitter-manager")
      end

      it "errors on unknown shell" do
        cmd = TreeSitterManager::CLI::Main.parse(["completions", "tcsh"])
        output = cmd.as(TreeSitterManager::CLI::Completions).run
        output.should contain("Unsupported shell")
      end
    end
  end
end
