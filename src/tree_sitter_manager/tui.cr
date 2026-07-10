module TreeSitterManager
  module Tui
    # Messages for the TUI (included in main lib for Model)
    record CycleThemeMsg
    record OpenFileMsg, path : String
    record QuitMsg
    record ThemeSearchMsg, query : String

    # Search result for theme jump-by-name
    record ThemeSearchResult, found : Bool, name : String?

    # The TUI Model
    class Model
      getter theme_name : String
      getter current_file : String?
      getter highlighted_content : String
      getter? quitting : Bool
      property theme_index : Int32

      def initialize
        config = Config.load
        @theme_name = config.theme
        @current_file = nil
        @highlighted_content = ""
        @quitting = false
        @theme_index = Themes::THEMES.index(config.theme) || 0
      end

      def update(msg) : Model
        case msg
        when CycleThemeMsg
          @theme_index = (@theme_index + 1) % Themes::THEMES.size
          @theme_name = Themes::THEMES[@theme_index]
          rehighlight
        when OpenFileMsg
          @current_file = msg.path
          rehighlight
        when QuitMsg
          @quitting = true
        when ThemeSearchMsg
          jump_to_theme(msg.query)
        end
        self
      end

      # Find the first theme whose name starts with the given prefix
      def jump_to_theme(prefix : String) : ThemeSearchResult
        return ThemeSearchResult.new(false, nil) if prefix.empty?
        lower = prefix.downcase
        idx = Themes::THEMES.index { |name| name.downcase.starts_with?(lower) }
        if idx
          @theme_index = idx
          @theme_name = Themes::THEMES[idx]
          rehighlight
          ThemeSearchResult.new(true, @theme_name)
        else
          ThemeSearchResult.new(false, nil)
        end
      end

      # Cycle theme backwards
      def cycle_theme_backwards : Nil
        @theme_index = (@theme_index - 1 + Themes::THEMES.size) % Themes::THEMES.size
        @theme_name = Themes::THEMES[@theme_index]
        rehighlight
      end

      # Foreground hex color from the theme's _normal key for preview swatch
      def theme_swatch_color : String?
        theme = Themes.from_str(@theme_name) || Themes.get(@theme_name)
        return nil unless theme
        style = theme.find_style("_normal")
        return nil unless style
        style.color.to_s
      end

      # Language name computed from current file
      def language_name : String?
        file = @current_file
        return nil unless file
        ext = File.extname(file).downcase
        lang = if ext.empty?
                 LanguageRegistry.language_for_extension(File.basename(file).downcase)
               else
                 LanguageRegistry.language_for_extension(ext.lstrip('.'))
               end
        lang
      end

      private def rehighlight : Nil
        file = @current_file
        return unless file && File.exists?(file)

        ext = File.extname(file).downcase
        lang = if ext.empty?
                 LanguageRegistry.language_for_extension(File.basename(file).downcase)
               else
                 LanguageRegistry.language_for_extension(ext.lstrip('.'))
               end

        return unless lang

        theme = Themes.from_str(@theme_name) || Themes.get(@theme_name)
        return unless theme

        source = File.read(file)
        hl = SourceHighlighter.new(lang)
        hl.theme = theme
        @highlighted_content = hl.highlight_to_terminal(source)
      rescue ex
        @highlighted_content = "Error: #{ex.message}"
      end
    end
  end
end
