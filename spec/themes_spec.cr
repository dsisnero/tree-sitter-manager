require "./spec_helper"

describe TreeSitterManager::Themes do
  describe ".dracula" do
    it "returns a resolved theme" do
      theme = TreeSitterManager::Themes.dracula
      theme.should be_a(TreeSitterManager::ResolvedTheme)
    end

    it "has keyword highlighting" do
      theme = TreeSitterManager::Themes.dracula
      s = theme.find_style("keyword")
      s.should_not be_nil
      s.not_nil!.color.to_s.should eq("#ff79c6")
    end

    it "has string highlighting" do
      theme = TreeSitterManager::Themes.dracula
      s = theme.find_style("string")
      s.should_not be_nil
      s.not_nil!.color.to_s.should eq("#f1fa8c")
    end

    it "has comment highlighting" do
      theme = TreeSitterManager::Themes.dracula
      s = theme.find_style("comment")
      s.should_not be_nil
      s.not_nil!.color.to_s.should eq("#6272a4")
    end

    it "has hierarchical fallback for keyword subtypes" do
      theme = TreeSitterManager::Themes.dracula
      s = theme.find_style("keyword.return")
      s.should_not be_nil
      # Falls back to keyword
      s.not_nil!.color.to_s.should eq("#ff79c6")
    end
  end

  describe ".nord" do
    it "returns a resolved theme" do
      theme = TreeSitterManager::Themes.nord
      theme.should be_a(TreeSitterManager::ResolvedTheme)
    end

    it "has specific nord colors" do
      theme = TreeSitterManager::Themes.nord
      # Keyword is frost-blue
      s = theme.find_style("keyword")
      s.should_not be_nil
      s.not_nil!.color.to_s.should eq("#81a1c1")
    end
  end

  describe ".catppuccin_mocha" do
    it "returns a resolved theme" do
      theme = TreeSitterManager::Themes.catppuccin_mocha
      theme.should be_a(TreeSitterManager::ResolvedTheme)
    end

    it "has catppuccin mauve for keywords" do
      theme = TreeSitterManager::Themes.catppuccin_mocha
      s = theme.find_style("keyword")
      s.should_not be_nil
      s.not_nil!.color.to_s.should eq("#cba6f7")
    end
  end

  describe ".github_light" do
    it "returns a resolved theme" do
      theme = TreeSitterManager::Themes.github_light
      theme.should be_a(TreeSitterManager::ResolvedTheme)
    end

    it "has dark text on light background" do
      theme = TreeSitterManager::Themes.github_light
      s = theme.find_style("_normal")
      s.should_not be_nil
      s.not_nil!.color.to_s.should eq("#1f2328")
    end
  end

  describe "theme listing" do
    it "lists available themes" do
      themes = TreeSitterManager::Themes.available
      themes.should contain("dracula")
      themes.should contain("nord")
      themes.should contain("catppuccin_mocha")
      themes.should contain("github_light")
    end
  end

  describe "theme lookup" do
    it "loads theme by name" do
      theme = TreeSitterManager::Themes.get("dracula")
      theme.should_not be_nil
    end

    it "returns nil for unknown theme" do
      theme = TreeSitterManager::Themes.get("nonexistent")
      theme.should be_nil
    end
  end

  describe ".tokyo_storm" do
    it "returns a resolved theme" do
      theme = TreeSitterManager::Themes.tokyo_storm
      theme.should be_a(TreeSitterManager::ResolvedTheme)
    end

    it "has keyword color and italic" do
      theme = TreeSitterManager::Themes.tokyo_storm
      s = theme.find_style("keyword").not_nil!
      s.color.to_s.should eq("#9d7cd8")
      s.italic.should be_true
    end

    it "has string color" do
      theme = TreeSitterManager::Themes.tokyo_storm
      s = theme.find_style("string").not_nil!
      s.color.to_s.should eq("#9ece6a")
    end

    it "has function color" do
      theme = TreeSitterManager::Themes.tokyo_storm
      s = theme.find_style("function").not_nil!
      s.color.to_s.should eq("#7aa2f7")
    end

    it "has type color" do
      theme = TreeSitterManager::Themes.tokyo_storm
      s = theme.find_style("type").not_nil!
      s.color.to_s.should eq("#2ac3de")
    end

    it "has comment in italic" do
      theme = TreeSitterManager::Themes.tokyo_storm
      s = theme.find_style("comment").not_nil!
      s.italic.should be_true
    end

    it "falls back to _normal for unknown keys" do
      theme = TreeSitterManager::Themes.tokyo_storm
      s = theme.find_style("_normal").not_nil!
      s.color.to_s.should eq("#c0caf5")
    end
  end
end
