require "bubbletea"
require "bubbles"
require "./tui"

# Add Tea::Msg to TUI messages so they can be sent through Tea::Model#update
struct TreeSitterManager::Tui::CycleThemeMsg
  include Tea::Msg
end

struct TreeSitterManager::Tui::OpenFileMsg
  include Tea::Msg
end

struct TreeSitterManager::Tui::QuitMsg
  include Tea::Msg
end

struct TreeSitterManager::Tui::InstallDoneMsg
  include Tea::Msg
  property language : String
  property success : Bool # ameba:disable Naming/PredicateName
  property error : String?

  def initialize(@language : String, @success : Bool, @error : String? = nil)
  end
end

module TreeSitterManager
  module Tui
    # Bubble Tea TUI app — interactive syntax highlighter
    class App
      include Tea::Model

      getter model : Model
      getter viewport : Bubbles::Viewport::Model
      getter help_model : Bubbles::Help::Model
      getter filepicker : Bubbles::Filepicker::Model?
      @screen_width : Int32 = 0
      @screen_height : Int32 = 0
      @search_input : String = ""
      @spinner : Bubbles::Spinner::Model? = nil
      @installing_lang : String? = nil
      @pending_file : String? = nil
      property? quitting : Bool = false
      property? help_shown : Bool = false
      property? picker_active : Bool = false
      property? search_active : Bool = false
      property? installing : Bool = false

      def initialize
        @model = Model.new
        @viewport = Bubbles::Viewport::Model.new
        @viewport.mouse_wheel_enabled = true
        @help_model = Bubbles::Help::Model.new
        @filepicker = nil
        @help_shown = false
        @picker_active = false
        @search_input = ""
        @search_active = false
      end

      def init : Tea::Cmd?
        Tea.window_size
      end

      def update(msg)
        case msg
        when Tea::KeyPressMsg
          if cmd = handle_key(msg)
            return cmd
          end
        when Bubbles::Filepicker::ReadDirMsg
          if fp = @filepicker
            result = fp.update(msg)
            @filepicker = result[0]
          end
        when Bubbles::Spinner::TickMsg
          if sp = @spinner
            result = sp.update(msg)
            @spinner = result[0]
            return {self, result[1]} if result[1]
          end
        when Tea::WindowSizeMsg
          @screen_width = msg.width
          @screen_height = msg.height
          @viewport.set_width(msg.width)
          @viewport.set_height(msg.height - 4)
          @help_model.set_width(msg.width)
          if fp = @filepicker
            fp.update(msg)
          end
          update_viewport_content
        when Tea::QuitMsg
          @quitting = true
          return {self, Tea.quit}
        when OpenFileMsg
          if @installing
            @pending_file = msg.path
          else
            if cmd = try_open_file(msg.path)
              return {self, cmd}
            end
          end
        when InstallDoneMsg
          @installing = false
          @spinner = nil
          @installing_lang = nil
          if msg.success && (pf = @pending_file)
            @pending_file = nil
            if cmd = try_open_file(pf)
              return {self, cmd}
            end
          elsif !msg.success
            @viewport.set_content("Error installing grammar '#{msg.language}': #{msg.error || "unknown error"}")
          end
        else
          @model.update(msg)
        end
        {self, nil}
      end

      private def try_open_file(path : String) : Tea::Cmd?
        lang = guess_language_from_path(path)
        if lang && !GrammarLoader.tree_sitter_available?(lang)
          @installing = true
          @installing_lang = lang
          sp = Bubbles::Spinner::Model.new
          sp.spinner = Bubbles::Spinner::MiniDot
          @spinner = sp
          @viewport.set_content("Installing grammar for #{lang}...")
          tick_cmd = Tea.tick(sp.spinner.fps) do
            Bubbles::Spinner::TickMsg.new(Time.local, sp.id, sp.tag)
          end
          return Tea.batch(install_grammar_cmd(lang), tick_cmd)
        end
        @model.update(OpenFileMsg.new(path))
        update_viewport_content
        nil
      end

      private def install_grammar_cmd(lang : String) : Tea::Cmd
        -> {
          result = GrammarManager.instance.install_grammar_sync(lang)
          InstallDoneMsg.new(lang, result.success?, result.error).as(Tea::Msg?)
        }
      end

      private def guess_language_from_path(path : String) : String?
        ext = File.extname(path).downcase
        lang = if ext.empty?
                 LanguageRegistry.language_for_extension(File.basename(path).downcase)
               else
                 LanguageRegistry.language_for_extension(ext.lstrip('.'))
               end
        lang
      end

      # Returns a {self, Tea::Cmd?} tuple if a command should be returned, nil otherwise
      private def handle_key(msg : Tea::KeyPressMsg) : Tuple(self, Tea::Cmd?)?
        if @picker_active
          if fp = @filepicker
            if msg.code == Tea::KeyEscape
              @filepicker = nil
              @picker_active = false
              return nil
            end

            result = fp.update(msg)
            @filepicker = result[0]
            cmd = result[1]

            selected, path = fp.did_select_file(msg)
            if selected && !path.empty?
              @model.update(OpenFileMsg.new(path))
              update_viewport_content
              @filepicker = nil
              @picker_active = false
            end

            return {self, cmd}
          end
          return nil
        end

        if @search_active
          handle_search_key(msg)
          return nil
        end

        if ctrl_pressed?(msg, 'o')
          fp = Bubbles::Filepicker::Model.new
          if @screen_height > 0
            fp.update(Tea::WindowSizeMsg.new(@screen_width, @screen_height))
          end
          @filepicker = fp
          @picker_active = true
          return {self, fp.init}
        end

        case msg.code
        when '/'.ord
          @search_active = true
          @search_input = ""
        when 'q'.ord
          @quitting = true
          return {self, Tea.quit}
        when 't'.ord
          @model.update(CycleThemeMsg.new)
          update_viewport_content
        when 'T'.ord
          @model.cycle_theme_backwards
          update_viewport_content
        when '?'.ord
          @help_shown = !@help_shown
          @help_model.show_all = @help_shown
        when Tea::KeyUp, Tea::KeyDown, Tea::KeyLeft, Tea::KeyRight,
             Tea::KeyPgUp, Tea::KeyPgDown, Tea::KeyHome, Tea::KeyEnd
          result = @viewport.update(msg)
          @viewport = result[0]
        end
        nil
      end

      private def handle_search_key(msg : Tea::KeyPressMsg) : Nil
        case msg.code
        when Tea::KeyEscape
          @search_active = false
          @search_input = ""
        when Tea::KeyEnter
          @search_active = false
        when Tea::KeyBackspace
          if @search_input.size > 0
            @search_input = @search_input[0..-2]
            if @search_input.empty?
              @search_active = false
            else
              @model.update(ThemeSearchMsg.new(@search_input))
              update_viewport_content
            end
          end
        else
          if msg.printable?
            @search_input += msg.text
            @model.update(ThemeSearchMsg.new(@search_input))
            update_viewport_content
          end
        end
      end

      # Check if a key press has a Ctrl+letter modifier
      private def ctrl_pressed?(msg : Tea::KeyPressMsg, char : Char) : Bool
        msg.code == char.ord && (msg.mod & Ultraviolet::ModCtrl) != 0
      end

      def view : Tea::View
        if @picker_active && (fp = @filepicker)
          body = fp.view
          v = Tea::View.new(content: body)
          v.alt_screen = true
          return v
        end

        header = Lipgloss::Style.new
          .foreground(Lipgloss::Color.rgb(255, 121, 198))
          .bold(true)
          .render(" tree-sitter-manager ")

        swatch_char = if swatch = @model.theme_swatch_color
                        Lipgloss::Style.new
                          .foreground(swatch)
                          .render("● ")
                      else
                        ""
                      end
        theme_line = Lipgloss::Style.new
          .foreground(Lipgloss::Color.rgb(139, 233, 253))
          .render("#{swatch_char}Theme: #{@model.theme_name}")

        spinner_view = if @installing && (sp = @spinner)
                         " #{sp.view} Installing grammar for #{@installing_lang}..."
                       else
                         ""
                       end

        search_line = if @search_active
                        Lipgloss::Style.new
                          .foreground(Lipgloss::Color.rgb(255, 255, 0))
                          .render("/#{@search_input}▌")
                      else
                        ""
                      end

        status = build_status_line
        help = @help_model.view(BindingInfo.new(@help_shown))

        # Count help lines to reserve proper space
        help_lines = help.empty? ? 0 : help.count('\n') + 1
        non_content = 3 + help_lines # header, theme_line, status
        non_content += 1 if @search_active
        non_content += 1 if @installing
        @viewport.set_height(Math.max(0, @screen_height - non_content))

        content = @viewport.view

        body = "#{header}\n#{theme_line}\n#{content}\n#{spinner_view}\n#{search_line}\n#{status}\n#{help}"

        v = Tea::View.new(content: body)
        v.alt_screen = true
        v
      end

      private def build_status_line : String
        file = @model.current_file
        lang = @model.language_name
        theme = @model.theme_name

        Lipgloss::Style.new
          .foreground(Lipgloss::Color.rgb(128, 128, 128))
          .render(
            if file
              " #{File.basename(file)} | #{lang || "?"} | #{theme}"
            else
              " No file open | #{theme}"
            end
          )
      end

      private def update_viewport_content : Nil
        if @model.highlighted_content.empty?
          hint = Lipgloss::Style.new
            .foreground(Lipgloss::Color.rgb(128, 128, 128))
            .render("Open a file (Ctrl+o) to highlight...")
          @viewport.set_content(hint)
        else
          @viewport.set_content(@model.highlighted_content)
        end
      end

      # Key binding info for the help bar
      class BindingInfo
        include Bubbles::Help::KeyMap

        getter show_all : Bool

        def initialize(@show_all : Bool = false)
        end

        def short_help : Array(Bubbles::Key::Binding)
          [
            Bubbles::Key.new_binding(
              Bubbles::Key.with_keys("q"),
              Bubbles::Key.with_help("q", "quit"),
            ),
            Bubbles::Key.new_binding(
              Bubbles::Key.with_keys("t/T"),
              Bubbles::Key.with_help("t/T", "theme"),
            ),
            Bubbles::Key.new_binding(
              Bubbles::Key.with_keys("↑/↓"),
              Bubbles::Key.with_help("↑/↓", "scroll"),
            ),
            Bubbles::Key.new_binding(
              Bubbles::Key.with_keys("/"),
              Bubbles::Key.with_help("/", "search theme"),
            ),
            Bubbles::Key.new_binding(
              Bubbles::Key.with_keys("Ctrl+o"),
              Bubbles::Key.with_help("Ctrl+o", "open"),
            ),
            Bubbles::Key.new_binding(
              Bubbles::Key.with_keys("?"),
              Bubbles::Key.with_help("?", "help"),
            ),
          ]
        end

        def full_help : Array(Array(Bubbles::Key::Binding))
          [
            [
              Bubbles::Key.new_binding(
                Bubbles::Key.with_keys("q"),
                Bubbles::Key.with_help("q", "quit"),
              ),
              Bubbles::Key.new_binding(
                Bubbles::Key.with_keys("t/T"),
                Bubbles::Key.with_help("t/T", "cycle theme"),
              ),
              Bubbles::Key.new_binding(
                Bubbles::Key.with_keys("/"),
                Bubbles::Key.with_help("/", "search theme"),
              ),
            ],
            [
              Bubbles::Key.new_binding(
                Bubbles::Key.with_keys("↑/↓"),
                Bubbles::Key.with_help("↑/↓", "scroll line"),
              ),
              Bubbles::Key.new_binding(
                Bubbles::Key.with_keys("PgUp/PgDn"),
                Bubbles::Key.with_help("PgUp/PgDn", "scroll page"),
              ),
            ],
            [
              Bubbles::Key.new_binding(
                Bubbles::Key.with_keys("Ctrl+o"),
                Bubbles::Key.with_help("Ctrl+o", "open file"),
              ),
              Bubbles::Key.new_binding(
                Bubbles::Key.with_keys("?"),
                Bubbles::Key.with_help("?", "toggle help"),
              ),
            ],
          ]
        end
      end
    end

    def self.run(file : String? = nil)
      app = App.new
      if file
        app.model.update(OpenFileMsg.new(file))
      end
      program = Tea::Program.new(app)
      program.fps = 30
      program.run
    end
  end
end
