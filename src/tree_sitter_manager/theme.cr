module TreeSitterManager
  # Raw theme data: map of theme key → value (color, link, or extended style).
  # Links (`$other_key`) are resolved via `#resolve` to produce a `ResolvedTheme`.
  class Theme
    # A single theme entry value
    enum EntryKind
      Simple   # hex color string or $link
      Extended # full style with optional link
    end

    record Entry,
      kind : EntryKind,
      color : String? = nil, # hex color or $link
      link : String? = nil,  # $link for extended entries
      bg : String? = nil,    # background hex color
      bold : Bool = false,
      italic : Bool = false,
      underline : Bool = false,
      strikethrough : Bool = false

    @entries : Hash(String, Entry)

    def initialize
      @entries = {} of String => Entry
    end

    # Number of entries
    def size : Int32
      @entries.size
    end

    # Set a simple theme entry: hex color or $link
    def set(key : String, value : String) : Nil
      @entries[key] = Entry.new(kind: EntryKind::Simple, color: value)
    end

    # Set an extended theme entry with full style options
    def set_extended(key : String, *, color : String? = nil, bg : String? = nil,
                     bold : Bool = false, italic : Bool = false,
                     underline : Bool = false, strikethrough : Bool = false,
                     link : String? = nil) : Nil
      @entries[key] = Entry.new(
        kind: EntryKind::Extended,
        color: color,
        bg: bg,
        bold: bold,
        italic: italic,
        underline: underline,
        strikethrough: strikethrough,
        link: link,
      )
    end

    # Resolve all links and produce a ResolvedTheme
    def resolve : ResolvedTheme
      styles = {} of String => Style

      @entries.each do |key, entry|
        style = resolve_entry(entry, Set(String).new)
        styles[key] = style
      end

      ResolvedTheme.new(styles)
    end

    private def resolve_entry(entry : Entry, visited : Set(String)) : Style
      case entry.kind
      when EntryKind::Simple
        val = entry.color.not_nil!
        if val.starts_with?('$')
          resolve_link(val[1..], visited)
        else
          Style.new(
            color: Color.from_hex(val),
            bold: entry.bold,
            italic: entry.italic,
            underline: entry.underline,
            strikethrough: entry.strikethrough,
          )
        end
      when EntryKind::Extended
        fg = entry.color
        ln = entry.link.try { |l| l.starts_with?('$') ? l[1..] : l }

        resolved_link = ln ? resolve_link(ln, visited) : nil

        color = if fg && fg.starts_with?('$')
                  resolve_link(fg[1..], visited).color
                elsif fg
                  Color.from_hex(fg)
                elsif resolved_link
                  resolved_link.color
                else
                  Color::WHITE
                end

        bg = if (b = entry.bg)
               b.starts_with?('$') ? resolve_link(b[1..], visited).color : Color.from_hex(b)
             elsif resolved_link
               resolved_link.bg
             end

        Style.new(
          color: color,
          bg: bg,
          bold: entry.bold || (resolved_link.try(&.bold) || false),
          italic: entry.italic || (resolved_link.try(&.italic) || false),
          underline: entry.underline || (resolved_link.try(&.underline) || false),
          strikethrough: entry.strikethrough || (resolved_link.try(&.strikethrough) || false),
        )
      else
        raise "Unknown entry kind: #{entry.kind}"
      end
    end

    private def resolve_link(key : String, visited : Set(String)) : Style
      raise "Circular link: #{key}" if visited.includes?(key)
      visited.add(key)

      if (entry = @entries[key]?)
        resolve_entry(entry, visited)
      else
        Style.new # default white
      end
    end
  end

  # Resolved theme: map of theme key → Style with hierarchical key fallback.
  class ResolvedTheme
    @styles : Hash(String, Style)

    def initialize(@styles : Hash(String, Style))
    end

    # Background color from _normal (used by renderers for global background fill).
    def bg : Color?
      @styles["_normal"]?.try(&.bg)
    end

    # Find the style for a theme key with hierarchical fallback.
    # e.g. "keyword.return.foo" → "keyword.return" → "keyword" → "_normal" → nil
    def find_style(key : String) : Style?
      # Try exact match
      return @styles[key] if @styles.has_key?(key)

      # Try hierarchical fallback: strip dot-separated suffixes
      parts = key.split('.')
      while parts.size > 0
        parts.pop
        candidate = parts.join('.')
        return @styles[candidate] if @styles.has_key?(candidate)
      end

      # Ultimate fallback: "_normal"
      @styles["_normal"]?
    end
  end
end
