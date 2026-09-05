# Reusable grammar and parser runtime plus an installation CLI.
#
# The runtime is exposed through `./tree_sitter_manager` and remains usable as a
# library (the syntax-highlighting CLI/TUI live in tree-sitter-manager-cli and
# depend on this shard). The `tree-sitter-manager` binary targets grammar
# installation and status; it activates only when invoked under that name so
# library and spec consumers are unaffected.
require "clip"
require "./tree_sitter_manager"
require "./tree_sitter_manager/grammar_batch_operations"
require "./tree_sitter_manager/language_registry"
require "./tree_sitter_manager/grammar_loader"

module TreeSitterManager
  module CLI
    # Shared exit-status counter so command `run` methods can signal failure
    # while still returning a printable message, which Clip requires.
    module Exit
      extend self

      def code : Int32
        @@code ||= 0
      end

      def code=(value : Int32) : Nil
        @@code = value
      end
    end

    def self.format_batch(result : BatchResult) : String
      String.build do |io|
        if result.value.nil?
          io << "Error: " << (result.error || "unknown error")
          Exit.code = 1
          next
        end

        result.successes.sort.each { |lang| io << "✓ " << lang << '\n' }
        result.failures.to_a.sort.each { |lang, error| io << "✗ " << lang << ": " << error << '\n' }

        Exit.code = result.failure_count > 0 ? 1 : 0
      end
    end

    # --- Install grammar(s) ---
    @[Clip::Doc("Install grammars (given languages, or all defaults with --all).")]
    struct Install
      include Clip::Mapper

      @[Clip::Doc("Languages to install.")]
      @[Clip::Argument]
      property languages : Array(String) = [] of String

      @[Clip::Doc("Install every default grammar.")]
      @[Clip::Option("--all")]
      property? all : Bool = false

      @[Clip::Doc("Reinstall even if already present.")]
      @[Clip::Option("--force")]
      property? force : Bool = false

      def run : String
        if @languages.empty? && !@all
          Exit.code = 1
          return "Error: specify at least one language, or use --all."
        end

        result = if @all
                   GrammarBatchOperations.install_all_defaults_async(@force).receive
                 else
                   GrammarBatchOperations.install_multiple_async(@languages, force: @force).receive
                 end

        TreeSitterManager::CLI.format_batch(result)
      end
    end

    # --- Ensure a single grammar ---
    @[Clip::Doc("Install or ensure a single grammar is available.")]
    struct EnsureGrammar
      include Clip::Mapper

      @[Clip::Doc("The language to ensure.")]
      @[Clip::Argument]
      property language : String

      def run : String
        result = GrammarManager.instance.ensure_grammar_with_result(@language)
        if result.success?
          "✓ #{@language} is ready."
        else
          Exit.code = 1
          "✗ #{@language}: #{result.error || "installation failed"}"
        end
      end
    end

    # --- Update grammars ---
    @[Clip::Doc("Update installed grammars.")]
    struct Update
      include Clip::Mapper

      @[Clip::Doc("Report which grammars have updates without installing.")]
      @[Clip::Option("--dry-run")]
      property? dry_run : Bool = false

      def run : String
        result = GrammarBatchOperations.update_all_async(@dry_run).receive
        TreeSitterManager::CLI.format_batch(result)
      end
    end

    # --- List languages ---
    @[Clip::Doc("List supported languages.")]
    struct Languages
      include Clip::Mapper

      def run : String
        LanguageRegistry.supported_languages.sort.join(", ")
      end
    end

    # --- Grammar installation status ---
    @[Clip::Doc("Show which default grammars are installed or missing.")]
    struct Status
      include Clip::Mapper

      def run : String
        result = GrammarBatchOperations.check_missing_defaults_async.receive
        value = result.value
        return "Error: #{result.error || "status check failed"}" unless value

        missing = value.select { |_, res| res.value == true }.keys.sort!
        installed = value.keys.select { |lang| !missing.includes?(lang) }.sort!

        String.build do |io|
          if installed.empty?
            io << "No default grammars installed.\n"
          else
            io << "Installed:\n"
            installed.each { |lang| io << "  ✓ " << lang << '\n' }
          end
          if missing.empty?
            io << "All default grammars installed.\n"
          else
            io << "Missing:\n"
            missing.each { |lang| io << "  ✗ " << lang << '\n' }
            io << "Run `tree-sitter-manager install --all` to install them.\n"
          end
        end
      end
    end

    # --- Top-level command router ---
    @[Clip::Doc("Tree-sitter grammar and parser manager.")]
    abstract struct Main
      include Clip::Mapper

      Clip.add_commands({
        "install"        => Install,
        "ensure-grammar" => EnsureGrammar,
        "update"         => Update,
        "languages"      => Languages,
        "status"         => Status,
      })

      # Run the CLI from ARGV, returning a process exit code.
      def self.run(argv = ARGV) : Int32
        Exit.code = 0
        TreeSitterManager::GrammarManager.init
        begin
          command = Main.parse(argv)
        rescue ex : Clip::ParsingError
          puts "Error: #{ex.message}"
          puts
          puts Main.help
          return 1
        end

        if command.is_a?(Main::Help)
          puts Main.help
        elsif command.responds_to?(:run)
          puts command.run
        else
          puts Main.help
        end

        Exit.code
      end
    end
  end
end

# Only act as a command-line tool when invoked as `tree-sitter-manager`, so that
# library and spec consumers that require this file never trigger the CLI.
if File.basename(PROGRAM_NAME) == "tree-sitter-manager"
  exit(TreeSitterManager::CLI::Main.run)
end
