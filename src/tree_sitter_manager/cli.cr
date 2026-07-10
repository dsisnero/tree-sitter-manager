require "clip"
require "./source_highlighter"
require "./themes"
require "./query_manager"
require "./language_registry"
require "./language_detection"

module TreeSitterManager
  module CLI
    # --- Highlight subcommand ---
    @[Clip::Doc("Highlight a source file.")]
    struct Highlight
      include Clip::Mapper

      @[Clip::Doc("The source file to highlight.")]
      @[Clip::Argument]
      property file : String

      @[Clip::Doc("Programming language (auto-detected from extension if omitted).")]
      @[Clip::Option("-l", "--lang")]
      property lang : String? = nil

      @[Clip::Doc("Color theme to use.")]
      @[Clip::Option("-t", "--theme")]
      property theme : String = ""

      @[Clip::Doc("Output format: terminal or html.")]
      @[Clip::Option("-f", "--format")]
      property format : String = ""

      def run : String
        config = TreeSitterManager::Config.load

        source = begin
          File.read(@file)
        rescue ex
          return "Error: could not read file '#{@file}': #{ex.message}"
        end

        lang = @lang || TreeSitterManager::CLI.guess_language(@file, source)
        unless lang
          return "Error: could not determine language from file extension. Use --lang to specify."
        end

        theme_name = @theme.empty? ? config.theme : @theme
        theme = TreeSitterManager::Themes.from_str(theme_name) || TreeSitterManager::Themes.get(theme_name)
        unless theme
          return "Error: unknown theme '#{theme_name}'. Use 'themes' command to list all #{TreeSitterManager::Themes::THEMES.size} themes."
        end

        output_format = @format.empty? ? config.format : @format

        begin
          hl = TreeSitterManager::SourceHighlighter.new(lang)
          hl.theme = theme

          case output_format
          when "html"
            hl.highlight_to_html(source)
          else
            hl.highlight_to_terminal(source)
          end
        rescue ex : TreeSitterManager::SourceHighlighter::GrammarNotFoundError
          "Error: grammar not found for '#{lang}'. Install it with: tree-sitter-manager ensure-grammar #{lang}"
        rescue ex
          "Error highlighting '#{lang}': #{ex.message} (#{ex.class})"
        end
      end
    end

    # --- Themes subcommand ---
    @[Clip::Doc("List available color themes.")]
    struct Themes
      include Clip::Mapper

      def run : String
        String.build do |io|
          io << "Available themes (#{TreeSitterManager::Themes::THEMES.size}):\n"
          TreeSitterManager::Themes::THEMES.each do |name|
            io << "  #{name}\n"
          end
        end
      end
    end

    # --- Languages subcommand ---
    @[Clip::Doc("List supported languages.")]
    struct Languages
      include Clip::Mapper

      def run : String
        String.build do |io|
          all = TreeSitterManager::LanguageRegistry.supported_languages
          io << "Known languages (#{all.size}):\n"
          all.sort.each_slice(8) do |group|
            io << "  " << group.join(", ") << '\n'
          end

          qlangs = TreeSitterManager::QueryManager.available_languages
          io << "\nLanguages with query files (#{qlangs.size}):\n"
          qlangs.sort.each_slice(8) do |group|
            io << "  " << group.join(", ") << '\n'
          end
        end
      end
    end

    # --- Queries subcommand ---
    @[Clip::Doc("Show preprocessed queries for a language.")]
    struct Queries
      include Clip::Mapper

      @[Clip::Doc("The language name.")]
      @[Clip::Argument]
      property language_name : String

      def run : String
        queries = TreeSitterManager::QueryManager.load_queries(@language_name)

        String.build do |io|
          io << "Queries for #{@language_name}:\n\n"

          io << "--- Highlights ---\n"
          if queries.highlights.empty?
            io << "  (none)\n"
          else
            io << queries.highlights
          end

          io << "\n\n--- Injections ---\n"
          if queries.injections.empty?
            io << "  (none)\n"
          else
            io << queries.injections
          end

          io << "\n\n--- Locals ---\n"
          if queries.locals.empty?
            io << "  (none)\n"
          else
            io << queries.locals
          end
          io << '\n'
        end
      end
    end

    # --- Stats subcommand ---
    @[Clip::Doc("Show installation statistics.")]
    struct Stats
      include Clip::Mapper

      def run : String
        String.build do |io|
          io << "tree-sitter-manager stats\n"
          io << "─────────────────────────\n"
          io << "  Languages:  #{TreeSitterManager::LanguageRegistry.supported_languages.size}\n"
          io << "  Extensions: #{TreeSitterManager::LanguageRegistry.supported_extensions.size}\n"
          io << "  Themes:     #{TreeSitterManager::Themes::THEMES.size}\n"
          io << "  Queries:    #{TreeSitterManager::QueryManager.available_languages.size}\n"
        end
      end
    end

    # --- Groups subcommand ---
    @[Clip::Doc("List semantic language groups and their members.")]
    struct Groups
      include Clip::Mapper

      @[Clip::Doc("Optional group name to filter.")]
      @[Clip::Argument]
      property group_name : String? = nil

      def run : String
        String.build do |io|
          groups = TreeSitterManager::LanguageRegistry::LANGUAGE_GROUPS

          if group = @group_name
            if members = groups[group]?
              io << "Group '#{group}' (#{members.size} languages):\n"
              members.each { |m| io << "  #{m}\n" }
            else
              io << "Unknown group '#{group}'.\n"
              io << "Available groups: #{groups.keys.join(", ")}\n"
            end
          else
            io << "Language groups (#{groups.size}):\n\n"
            groups.each do |name, members|
              io << "  #{name} (#{members.size}): #{members.join(", ")}\n"
            end
          end
        end
      end
    end

    # --- Version subcommand ---
    @[Clip::Doc("Print version information.")]
    struct Version
      include Clip::Mapper

      VERSION = {{ read_file("shard.yml").lines.select(&.starts_with?("version:")).first.split(':')[1].strip }}

      def run : String
        VERSION
      end
    end

    # --- Doctor subcommand ---
    @[Clip::Doc("Check grammar, query, and cache health.")]
    struct Doctor
      include Clip::Mapper

      def run : String
        String.build do |io|
          io << "tree-sitter-manager doctor\n"
          io << "───────────────────────────\n\n"

          lang_count = TreeSitterManager::LanguageRegistry.supported_languages.size
          io << "✓ Language registry: #{lang_count} languages\n"

          qlangs = TreeSitterManager::QueryManager.available_languages
          io << "✓ Query files: #{qlangs.size} languages\n"

          installed = qlangs.select { |l| TreeSitterManager::GrammarLoader.tree_sitter_available?(l) }
          if installed.empty?
            io << "○ Grammars: none installed (will install on demand)\n"
          else
            io << "✓ Grammars installed: #{installed.size}\n"
            installed.each { |l| io << "    #{l}\n" }
          end

          cache_dir = TreeSitterManager::GrammarManager.instance.cache_dir
          if cache_dir && Dir.exists?(cache_dir)
            io << "✓ Cache: #{cache_dir}\n"
          else
            io << "○ Cache: not configured\n"
          end

          io << "\nAll checks passed.\n" if installed.any? || lang_count > 0
        end
      end
    end

    # --- Completions subcommand ---
    @[Clip::Doc("Generate shell completion scripts (bash, zsh, fish).")]
    struct Completions
      include Clip::Mapper

      @[Clip::Doc("Target shell: bash, zsh, or fish.")]
      @[Clip::Argument]
      property shell : String

      def run : String
        case @shell.downcase
        when "bash" then generate_bash
        when "zsh"  then generate_zsh
        when "fish" then generate_fish
        else
          "Error: Unsupported shell '#{@shell}'. Supported shells: bash, zsh, fish."
        end
      end

      COMMANDS = %w[highlight themes languages queries stats groups version doctor completions]

      private def generate_bash : String
        <<-BASH
        # tree-sitter-manager bash completion
        _tree_sitter_manager() {
          local cur="${COMP_WORDS[COMP_CWORD]}"
          local prev="${COMP_WORDS[COMP_CWORD-1]}"
          if [ "$COMP_CWORD" -eq 1 ]; then
            COMPREPLY=( $(compgen -W "#{COMMANDS.join(" ")}" -- "$cur") )
          fi
        }
        complete -F _tree_sitter_manager tree-sitter-manager
        BASH
      end

      private def generate_zsh : String
        cmds = COMMANDS.join(" ")
        <<-ZSH
        # tree-sitter-manager zsh completion
        _tree_sitter_manager() {
          local state
          _arguments "1: :(#{cmds})" && return 0
        }
        (( $+commands[tree-sitter-manager] )) && compdef _tree_sitter_manager tree-sitter-manager
        ZSH
      end

      private def generate_fish : String
        <<-FISH
        # tree-sitter-manager fish completion
        complete -c tree-sitter-manager -f
        #{COMMANDS.map { |c| "complete -c tree-sitter-manager -n \"__fish_use_subcommand\" -a #{c}" }.join("\n")}
        FISH
      end
    end

    # --- Top-level command router ---
    @[Clip::Doc("Tree-sitter manager — manage grammars, queries, and syntax highlighting.")]
    abstract struct Main
      include Clip::Mapper

      Clip.add_commands({
        "highlight"   => Highlight,
        "themes"      => Themes,
        "languages"   => Languages,
        "queries"     => Queries,
        "stats"       => Stats,
        "groups"      => Groups,
        "version"     => Version,
        "doctor"      => Doctor,
        "completions" => Completions,
      })

      # Run the CLI from ARGV
      def self.run(argv = ARGV) : Nil
        begin
          command = Main.parse(argv)
        rescue ex : Clip::ParsingError
          puts "Error: #{ex.message}"
          puts
          puts Main.help
          return
        end

        if command.is_a?(Main::Help)
          puts Main.help
        elsif command.responds_to?(:run)
          puts command.run
        end
      end
    end

    # --- Utility ---

    # Guess language from file extension using the language registry.
    # Falls back to content-based detection, then filename-based detection.
    def self.guess_language(file : String, content : String? = nil) : String?
      ext = File.extname(file).downcase

      unless ext.empty?
        ext_key = ext.lstrip('.')

        # Use content-based resolution for ambiguous extensions
        if content && !content.empty?
          if lang = LanguageDetection.resolve(ext_key, content)
            return lang if LanguageRegistry.get_language_info(lang)
          end
        end

        # Fall back to simple extension lookup
        if lang = LanguageRegistry.language_for_extension(ext_key)
          return lang
        end
      end

      if content && !content.empty?
        if detected = LanguageDetection.detect_from_content(content)
          return detected if LanguageRegistry.get_language_info(detected)
        end
      end

      basename = File.basename(file).downcase
      case basename
      when "makefile", "gnumakefile" then return "make"
      when "dockerfile"              then return "dockerfile"
      when "vagrantfile"             then return "ruby"
      end

      nil
    end
  end
end
