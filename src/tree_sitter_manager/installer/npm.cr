require "./base"
require "../language_registry"

module TreeSitterManager
  module Installer
    # Installs a grammar package into an isolated npm workspace.
    class Npm < Base
      def installation_method : Symbol
        :npm
      end

      def initialize(@package_name : String? = nil, @npm_command : String = "npm")
      end

      def download(language : String, temporary_directory : String) : BoolResult
        package = package_for(language)
        output = IO::Memory.new
        error = IO::Memory.new
        status = Process.run(@npm_command, ["install", package],
          chdir: temporary_directory,
          output: output,
          error: error)
        return BoolResult.success if status.success?

        BoolResult.failure("npm install failed", {"language" => language, "package" => package, "error" => error.to_s})
      rescue ex
        BoolResult.failure("npm installer error: #{ex.message}", {"language" => language})
      end

      def create_manifest(language : String, temporary_directory : String) : GrammarMetadata
        package = package_for(language)
        GrammarMetadata.new(
          url: "https://registry.npmjs.org/#{package}",
          type: "npm",
          package_name: package,
          language: language,
          installed_at: Time.utc,
          last_updated: Time.utc,
        )
      end

      private def package_for(language : String) : String
        @package_name || LanguageRegistry.package_name(language) || "tree-sitter-#{language}"
      end
    end
  end
end
