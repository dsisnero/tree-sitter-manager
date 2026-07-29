require "tree_sitter"
require "./grammar_loader"
require "./grammar_manager"
require "./parser_language_resolver"
require "./result"

module TreeSitterManager
  module Parser
    record ParseArtifact, tree : ::TreeSitter::Tree?

    class LanguageGateway
      def load(language : String) : ::TreeSitter::Language?
        GrammarLoader.load_language(language)
      end

      def ensure(language : String, timeout_ms : Int32) : Bool
        GrammarManager.init
        GrammarManager.instance.ensure_grammar(language, timeout_ms)
      end
    end

    # Manager-owned parsing lifecycle. Chiasmus-specific adapter languages are
    # intentionally handled outside this reusable service.
    class Service
      def initialize(@resolver = LanguageResolver.new, @gateway = LanguageGateway.new)
        @state_mutex = Mutex.new
        @grammar_cache = {} of String => ::TreeSitter::Language
        @pending_requests = {} of String => Array(Channel(Result(::TreeSitter::Language?)))
      end

      def parse_async(content : String, file_path : String, timeout_ms : Int32 = 30_000) : Channel(Result(ParseArtifact))
        result = Channel(Result(ParseArtifact)).new(1)

        spawn do
          begin
            result.send(parse_result(content, file_path, timeout_ms))
          ensure
            result.close
          end
        end

        result
      end

      def parse(content : String, file_path : String, timeout_ms : Int32 = 30_000) : ::TreeSitter::Tree?
        result = parse_result(content, file_path, timeout_ms)
        result.value.try(&.tree)
      end

      def get_language_for_file(file_path : String) : String?
        @resolver.language_for_file(file_path)
      end

      def supported_extensions : Array(String)
        @resolver.supported_extensions
      end

      def grammar_language_for_file(file_path : String) : String?
        @resolver.grammar_language_for_file(file_path)
      end

      def supports_language_async?(language : String) : Channel(Bool)
        result = Channel(Bool).new(1)

        spawn do
          begin
            result.send(@resolver.supported_languages.includes?(language))
          ensure
            result.close
          end
        end

        result
      end

      def supports_language?(language : String) : Bool
        @resolver.supported_languages.includes?(language)
      end

      def supported_languages_async : Channel(Array(String))
        result = Channel(Array(String)).new(1)

        spawn do
          begin
            result.send(supported_languages)
          ensure
            result.close
          end
        end

        result
      end

      def supported_languages : Array(String)
        @resolver.supported_languages
      end

      # Drops loaded-language entries while preserving any active waiters. An
      # in-flight resolution must still notify every caller that joined it.
      def clear_cache : Nil
        @state_mutex.synchronize { @grammar_cache.clear }
      end

      def shutdown : Nil
        clear_cache
      end

      def get_language_async(language : String, timeout_ms : Int32 = 60_000) : Channel(Result(::TreeSitter::Language?))
        result = Channel(Result(::TreeSitter::Language?)).new(1)
        start_resolution = false

        @state_mutex.synchronize do
          if cached = @grammar_cache[language]?
            result.send(Result(::TreeSitter::Language?).success(cached))
            result.close
          elsif waiters = @pending_requests[language]?
            waiters << result
          else
            @pending_requests[language] = [result]
            start_resolution = true
          end
        end

        spawn { resolve_language(language, timeout_ms) } if start_resolution
        result
      end

      private def parse_result(content : String, file_path : String, timeout_ms : Int32) : Result(ParseArtifact)
        language = grammar_language_for_file(file_path)
        return Result(ParseArtifact).failure("Unsupported file extension", {"file_path" => file_path}) unless language

        language_result = get_language_async(language, timeout_ms).receive
        lang = language_result.value
        return Result(ParseArtifact).failure("Failed to get language", {"language" => language, "file_path" => file_path}) unless lang

        parser = ::TreeSitter::Parser.new(language: lang)
        tree = parser.parse(nil, IO::Memory.new(content))
        Result(ParseArtifact).success(ParseArtifact.new(tree))
      rescue ex
        Result(ParseArtifact).failure("Unexpected parse error: #{ex.message}", {"file_path" => file_path})
      end

      private def resolve_language(language : String, timeout_ms : Int32) : Nil
        lang = @gateway.load(language)
        lang = @gateway.load(language) if !lang && @gateway.ensure(language, timeout_ms)
        outcome = lang ? Result(::TreeSitter::Language?).success(lang) : Result(::TreeSitter::Language?).failure("Failed to get language", {"language" => language})

        waiters = @state_mutex.synchronize do
          @grammar_cache[language] = lang if lang
          @pending_requests.delete(language) || [] of Channel(Result(::TreeSitter::Language?))
        end
        waiters.each do |waiter|
          waiter.send(outcome)
          waiter.close
        end
      end
    end

    @@service = Service.new

    def self.service : Service
      @@service
    end

    def self.service=(service : Service) : Service
      @@service = service
    end

    def self.language_for_file(file_path : String) : String?
      service.get_language_for_file(file_path)
    end

    def self.get_language_for_file(file_path : String) : String?
      service.get_language_for_file(file_path)
    end

    def self.grammar_language_for_file(file_path : String) : String?
      service.grammar_language_for_file(file_path)
    end

    def self.supported_extensions : Array(String)
      service.supported_extensions
    end

    def self.get_language_async(language : String, timeout_ms : Int32 = 60_000) : Channel(Result(::TreeSitter::Language?))
      service.get_language_async(language, timeout_ms)
    end

    def self.get_language(language : String, timeout_ms : Int32 = 60_000) : ::TreeSitter::Language?
      service.get_language_async(language, timeout_ms).receive.value
    end

    def self.supports_language_async?(language : String) : Channel(Bool)
      service.supports_language_async?(language)
    end

    def self.supports_language?(language : String) : Bool
      service.supports_language?(language)
    end

    def self.supported_languages_async : Channel(Array(String))
      service.supported_languages_async
    end

    def self.supported_languages : Array(String)
      service.supported_languages
    end

    def self.clear_cache : Nil
      service.clear_cache
    end

    def self.shutdown : Nil
      service.shutdown
    end

    def self.parse_async(content : String, file_path : String, timeout_ms : Int32 = 30_000) : Channel(Result(ParseArtifact))
      service.parse_async(content, file_path, timeout_ms)
    end

    def self.parse(content : String, file_path : String, timeout_ms : Int32 = 30_000) : ::TreeSitter::Tree?
      service.parse(content, file_path, timeout_ms)
    end
  end
end
