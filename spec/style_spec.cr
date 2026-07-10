require "./spec_helper"

describe TreeSitterManager::Color do
  describe ".new" do
    it "creates from RGB values" do
      c = TreeSitterManager::Color.new(255, 128, 0)
      c.r.should eq(255)
      c.g.should eq(128)
      c.b.should eq(0)
    end

    it "clamps values to 0-255" do
      c = TreeSitterManager::Color.new(300, -10, 128)
      c.r.should eq(255)
      c.g.should eq(0)
      c.b.should eq(128)
    end

    it "parses hex colors" do
      c = TreeSitterManager::Color.from_hex("#ff8000")
      c.r.should eq(255)
      c.g.should eq(128)
      c.b.should eq(0)
    end

    it "parses hex colors without #" do
      c = TreeSitterManager::Color.from_hex("ff8000")
      c.r.should eq(255)
      c.g.should eq(128)
      c.b.should eq(0)
    end

    it "parses short hex colors" do
      c = TreeSitterManager::Color.from_hex("#f80")
      c.r.should eq(255)
      c.g.should eq(136)
      c.b.should eq(0)
    end

    it "returns white for invalid hex" do
      c = TreeSitterManager::Color.from_hex("invalid")
      c.should eq(TreeSitterManager::Color.new(255, 255, 255))
    end

    it "provides ANSI escape code" do
      c = TreeSitterManager::Color.new(255, 128, 0)
      c.ansi_fg.should eq("38;2;255;128;0")
      c.ansi_bg.should eq("48;2;255;128;0")
    end
  end

  describe "#to_s" do
    it "formats as hex" do
      c = TreeSitterManager::Color.new(255, 128, 0)
      c.to_s.should eq("#ff8000")
    end
  end
end

describe TreeSitterManager::Style do
  describe ".new" do
    it "creates default style" do
      s = TreeSitterManager::Style.new
      s.color.r.should eq(255)
      s.color.g.should eq(255)
      s.color.b.should eq(255)
      s.bg.should be_nil
      s.bold.should be_false
      s.italic.should be_false
      s.underline.should be_false
      s.strikethrough.should be_false
    end

    it "creates with foreground color only" do
      s = TreeSitterManager::Style.new(TreeSitterManager::Color.new(255, 0, 0))
      s.color.r.should eq(255)
      s.color.g.should eq(0)
      s.bg.should be_nil
    end

    it "creates with full options" do
      s = TreeSitterManager::Style.new(
        color: TreeSitterManager::Color.new(255, 0, 0),
        bg: TreeSitterManager::Color.new(0, 0, 255),
        bold: true,
        italic: true,
        underline: true,
        strikethrough: true,
      )
      s.color.r.should eq(255)
      s.bg.not_nil!.b.should eq(255)
      s.bold.should be_true
      s.italic.should be_true
      s.underline.should be_true
      s.strikethrough.should be_true
    end
  end
end
