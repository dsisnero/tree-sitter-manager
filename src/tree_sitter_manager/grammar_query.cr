require "./grammar_loader"

module TreeSitterManager
  # Read-only grammar lookup facade.
  #
  # This deliberately does not initialize GrammarManager or trigger an
  # installation. Applications may register sidecar directories with
  # GrammarLoader before querying.
  module GrammarQuery
    extend self

    def path(language : String) : String?
      GrammarLoader.find_grammar_library(language)
    end

    def path_async(language : String) : Channel(String?)
      result = Channel(String?).new

      spawn do
        begin
          result.send(path(language))
        ensure
          result.close
        end
      end

      result
    end

    def available?(language : String) : Bool
      !path(language).nil?
    end

    def available_async(language : String) : Channel(Bool)
      result = Channel(Bool).new

      spawn do
        begin
          result.send(available?(language))
        ensure
          result.close
        end
      end

      result
    end
  end
end
