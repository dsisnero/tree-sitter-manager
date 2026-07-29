require "./language_registry"

module TreeSitterManager
  module Parser
    # Resolves file paths to canonical Tree-sitter grammar languages.
    class LanguageResolver
      def language_for_file(file_path : String) : String?
        LanguageRegistry.language_for_extension(normalized_extension(file_path))
      end

      def grammar_language_for_file(file_path : String) : String?
        language_for_file(file_path)
      end

      def supported_extensions : Array(String)
        LanguageRegistry.supported_extensions.sort!
      end

      def supported_languages : Array(String)
        LanguageRegistry.supported_languages.sort!
      end

      private def normalized_extension(file_path : String) : String
        File.extname(file_path).downcase.lstrip('.')
      end
    end
  end
end
