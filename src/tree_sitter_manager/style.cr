module TreeSitterManager
  # 8-bit RGB color (0-255 per channel).
  struct Color
    getter r : UInt8
    getter g : UInt8
    getter b : UInt8

    def initialize(r : Int, g : Int, b : Int)
      @r = clamp(r)
      @g = clamp(g)
      @b = clamp(b)
    end

    # Parse from hex string: "#ff8000", "ff8000", "#f80"
    def self.from_hex(hex : String) : Color
      hex = hex.lstrip('#')
      case hex.size
      when 6
        Color.new(
          hex[0, 2].to_i(16),
          hex[2, 2].to_i(16),
          hex[4, 2].to_i(16),
        )
      when 3
        Color.new(
          (hex[0].to_s * 2).to_i(16),
          (hex[1].to_s * 2).to_i(16),
          (hex[2].to_s * 2).to_i(16),
        )
      else
        WHITE
      end
    rescue
      WHITE
    end

    # ANSI true-color foreground escape code: "38;2;R;G;B"
    def ansi_fg : String
      "38;2;#{@r};#{@g};#{@b}"
    end

    # ANSI true-color background escape code: "48;2;R;G;B"
    def ansi_bg : String
      "48;2;#{@r};#{@g};#{@b}"
    end

    def to_s(io : IO) : Nil
      io << sprintf("#%02x%02x%02x", @r, @g, @b)
    end

    # Predefined colors
    WHITE = Color.new(255, 255, 255)
    BLACK = Color.new(0, 0, 0)
    RED   = Color.new(255, 0, 0)
    GREEN = Color.new(0, 255, 0)
    BLUE  = Color.new(0, 0, 255)

    private def clamp(value : Int) : UInt8
      value.clamp(0, 255).to_u8
    end
  end

  # Text style: foreground color, optional background, and modifiers.
  struct Style
    getter color : Color
    getter bg : Color?
    getter bold : Bool
    getter italic : Bool
    getter underline : Bool
    getter strikethrough : Bool

    def initialize(
      @color : Color = Color::WHITE,
      @bg : Color? = nil,
      @bold : Bool = false,
      @italic : Bool = false,
      @underline : Bool = false,
      @strikethrough : Bool = false,
    )
    end

    # Create a style with only a foreground color
    def self.color_only(color : Color) : Style
      Style.new(color: color)
    end

    # NONE style: fully transparent, used for "none" theme key
    NONE = new(
      color: Color.new(0, 0, 0),
      bold: false,
      italic: false,
      underline: false,
      strikethrough: false,
    )

    def to_s(io : IO) : Nil
      io << "Style("
      io << "fg=#{@color}"
      if bg = @bg
        io << ", bg=#{bg}"
      end
      io << ", bold" if @bold
      io << ", italic" if @italic
      io << ", underline" if @underline
      io << ", strikethrough" if @strikethrough
      io << ")"
    end
  end
end
