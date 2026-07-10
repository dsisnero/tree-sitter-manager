module TreeSitterManager
  module Renderers
    # A highlight span: byte range [start, end) with a style and optional theme key.
    #
    # When `theme_key` is set and a `theme` is provided to the renderer,
    # the theme overrides the span's `style`.
    struct HighlightSpan
      getter start : Int32
      getter end_ : Int32
      getter style : Style
      getter theme_key : String?

      def initialize(@start : Int32, @end_ : Int32, @style : Style = Style.new, @theme_key : String? = nil)
      end

      def size : Int32
        @end_ - @start
      end
    end

    # Renderer abstraction — ported from syntastica's Renderer trait.
    # Implement this to support custom output formats (LaTeX, SVG, Typst, etc.).
    #
    # The render pipeline:
    #   1. head()           — output preamble
    #   2. For each span:
    #      - unstyled(text) — render text without style
    #      - styled(text, style) — render text with a style
    #   3. tail()           — output postamble
    module Renderer
      abstract def head : String?
      abstract def tail : String?
      abstract def unstyled(text : String) : String
      abstract def styled(text : String, style : Style) : String
      abstract def escape(text : String) : String
    end

    # Render source text with highlight spans using a Renderer and optional theme.
    # Ported from syntastica's `render()` function.
    #
    # Spans must be sorted by start position and non-overlapping.
    def self.render(source : String, spans : Array(HighlightSpan), renderer : Renderer, theme : ResolvedTheme?) : String
      String.build do |io|
        if head = renderer.head
          io << head
        end

        if spans.empty?
          io << renderer.escape(source)
        else
          pos = 0
          sorted = spans.sort_by(&.start)

          sorted.each do |span|
            next if span.start >= source.size
            span_end = {span.end_, source.size}.min

            if pos < span.start
              text = source[pos...span.start]
              io << renderer.unstyled(renderer.escape(text))
            end

            style = if theme && (key = span.theme_key)
                      theme.find_style(key) || span.style
                    else
                      span.style
                    end

            text = source[span.start...span_end]
            io << renderer.styled(renderer.escape(text), style)

            pos = span_end
          end

          if pos < source.size
            text = source[pos..]
            io << renderer.unstyled(renderer.escape(text))
          end
        end

        if tail = renderer.tail
          io << tail
        end
      end
    end

    # ── Built-in Renderer Implementations ──

    # TerminalRenderer — ANSI true-color terminal output.
    # Ported from syntastica's TerminalRenderer.
    class TerminalRenderer
      include Renderer

      ANSI_RESET = "\e[0m"

      # Global background color (from theme's _normal). Applied to all text,
      # including unstyled segments, matching syntastica's behavior.
      property background_color : Color?

      def initialize(@background_color : Color? = nil)
      end

      def head : String?
        nil
      end

      def tail : String?
        nil
      end

      def escape(text : String) : String
        text
      end

      def unstyled(text : String) : String
        if bg = @background_color
          "\e[#{bg.ansi_bg}m#{text}#{ANSI_RESET}"
        else
          text
        end
      end

      def styled(text : String, style : Style) : String
        codes = [] of String
        codes << style.color.ansi_fg
        bg = style.bg || @background_color
        if bg
          codes << bg.ansi_bg
        end
        codes << "1" if style.bold
        codes << "3" if style.italic
        codes << "4" if style.underline
        codes << "9" if style.strikethrough
        "\e[#{codes.join(";")}m#{text}#{ANSI_RESET}"
      end
    end

    # HtmlRenderer — HTML with inline CSS spans.
    # Implements Renderer for custom pipeline use.
    class HtmlRenderer
      include Renderer

      CSS_START = "<pre style=\"font-family:monospace;white-space:pre-wrap;line-height:1.4\">"
      CSS_END   = "</pre>"

      def head : String?
        CSS_START
      end

      def tail : String?
        CSS_END
      end

      def escape(text : String) : String
        text
          .gsub("&", "&amp;")
          .gsub("<", "&lt;")
          .gsub(">", "&gt;")
          .gsub("\"", "&quot;")
      end

      def unstyled(text : String) : String
        text
      end

      def styled(text : String, style : Style) : String
        css = style_to_css(style)
        "<span style=\"#{css}\">#{text}</span>"
      end

      private def style_to_css(style : Style) : String
        parts = [] of String
        parts << "color:#{style.color}"
        if bg = style.bg
          parts << "background-color:#{bg}"
        end
        parts << "font-weight:bold" if style.bold
        parts << "font-style:italic" if style.italic
        if style.underline && style.strikethrough
          parts << "text-decoration:underline line-through"
        elsif style.underline
          parts << "text-decoration:underline"
        elsif style.strikethrough
          parts << "text-decoration:line-through"
        end
        parts.join(";")
      end
    end

    # ── Legacy Convenience Modules (backward compatible) ──

    # Direct module-level render methods for backward compatibility
    module Terminal
      ANSI_RESET = "\e[0m"

      def self.render(source : String, spans : Array(HighlightSpan), theme : ResolvedTheme?) : String
        bg = theme.try(&.bg)
        Renderers.render(source, spans, TerminalRenderer.new(bg), theme)
      end
    end

    module Html
      def self.render(source : String, spans : Array(HighlightSpan), theme : ResolvedTheme?) : String
        Renderers.render(source, spans, HtmlRenderer.new, theme)
      end
    end
  end
end
