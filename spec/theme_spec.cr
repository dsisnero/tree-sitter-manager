require "./spec_helper"

describe TreeSitterManager::Theme do
  describe ".new" do
    it "creates an empty theme" do
      theme = TreeSitterManager::Theme.new
      theme.size.should eq(0)
    end

    it "adds entries with simple color values" do
      theme = TreeSitterManager::Theme.new
      theme.set("keyword", "#c678dd")
      theme.set("string", "#98c379")
      theme.size.should eq(2)
    end

    it "adds entries with links" do
      theme = TreeSitterManager::Theme.new
      theme.set("purple", "#c678dd")
      theme.set("keyword", "$purple")
      theme.size.should eq(2)
    end

    it "adds entries with full style" do
      theme = TreeSitterManager::Theme.new
      theme.set_extended("comment",
        color: "#5c6370",
        italic: true,
      )
      theme.size.should eq(1)
    end
  end

  describe "#resolve" do
    it "resolves simple colors to styles" do
      theme = TreeSitterManager::Theme.new
      theme.set("keyword", "#c678dd")
      theme.set("string", "#98c379")

      resolved = theme.resolve
      resolved.find_style("keyword").not_nil!.color.to_s.should eq("#c678dd")
      resolved.find_style("string").not_nil!.color.to_s.should eq("#98c379")
    end

    it "resolves link chains" do
      theme = TreeSitterManager::Theme.new
      theme.set("purple", "#c678dd")
      theme.set("keyword", "$purple")
      theme.set("keyword.function", "$keyword")

      resolved = theme.resolve
      resolved.find_style("keyword.function").not_nil!.color.to_s.should eq("#c678dd")
      resolved.find_style("keyword").not_nil!.color.to_s.should eq("#c678dd")
    end

    it "handles extended styles with links" do
      theme = TreeSitterManager::Theme.new
      theme.set("purple", "#c678dd")
      theme.set_extended("keyword",
        color: "$purple",
        bold: true,
      )

      resolved = theme.resolve
      s = resolved.find_style("keyword").not_nil!
      s.color.to_s.should eq("#c678dd")
      s.bold.should be_true
    end

    it "handles extended styles with no color (link only)" do
      theme = TreeSitterManager::Theme.new
      theme.set("green", "#98c379")
      theme.set_extended("comment",
        link: "$green",
        italic: true,
      )

      resolved = theme.resolve
      s = resolved.find_style("comment").not_nil!
      s.italic.should be_true
      s.color.to_s.should eq("#98c379")
    end
  end

  describe "ResolvedTheme#find_style" do
    it "does hierarchical key fallback" do
      theme = TreeSitterManager::Theme.new
      theme.set("keyword", "#c678dd")
      theme.set("function", "#61afef")

      resolved = theme.resolve

      # Exact match
      resolved.find_style("keyword").not_nil!.color.to_s.should eq("#c678dd")

      # Hierarchical fallback: keyword.return → keyword
      resolved.find_style("keyword.return").not_nil!.color.to_s.should eq("#c678dd")

      # Hierarchical fallback: keyword.conditional.ternary → keyword
      resolved.find_style("keyword.conditional.ternary").not_nil!.color.to_s.should eq("#c678dd")
    end

    it "returns nil for unmatched keys" do
      theme = TreeSitterManager::Theme.new
      theme.set("_normal", "#abb2bf")

      resolved = theme.resolve
      # Only _normal is defined, everything else falls back to _normal
      resolved.find_style("nonexistent").not_nil!.color.to_s.should eq("#abb2bf")
    end

    it "preserves modifier-only styles through fallback" do
      theme = TreeSitterManager::Theme.new
      theme.set("_normal", "#abb2bf")
      theme.set_extended("comment",
        link: "$_normal",
        italic: true,
      )

      resolved = theme.resolve
      s = resolved.find_style("comment").not_nil!
      s.color.to_s.should eq("#abb2bf")
      s.italic.should be_true

      # comment.todo should fallback to comment (keeping italic)
      s2 = resolved.find_style("comment.todo").not_nil!
      s2.color.to_s.should eq("#abb2bf")
      s2.italic.should be_true
    end
  end
end
