require "./base"
require "../grammar_operations"
require "../language_registry"

module TreeSitterManager
  module Installer
    # Clones a grammar repository and builds its parser C sources directly.
    class GitCc < Base
      def installation_method : Symbol
        :cc
      end

      def initialize(@repository_url : String? = nil, @revision : String? = nil, @branch : String? = nil, @tree_sitter_command : String = "tree-sitter")
      end

      def download(language : String, temporary_directory : String) : BoolResult
        repository = repository_url_for(language)
        clone_error = IO::Memory.new
        clone_args = ["clone"] of String
        clone_args.concat(["--depth", "1"]) unless pinned_revision_for(language)
        clone_args.concat([repository, "."])
        clone = Process.run("git", clone_args,
          chdir: temporary_directory,
          output: Process::Redirect::Pipe,
          error: clone_error)
        unless clone.success?
          return BoolResult.failure("git clone failed", {"language" => language, "error" => clone_error.to_s.strip})
        end

        if revision = pinned_revision_for(language)
          checkout = Process.run("git", ["checkout", "--detach", revision], chdir: temporary_directory, error: Process::Redirect::Pipe)
          return BoolResult.failure("git checkout pinned revision failed", {"language" => language, "revision" => revision}) unless checkout.success?
        end

        unless File.exists?(File.join(temporary_directory, "src", "parser.c"))
          generated = Process.run(@tree_sitter_command, ["generate"], chdir: temporary_directory)
          return BoolResult.failure("tree-sitter generate failed", {"language" => language}) unless generated.success?
        end

        compiled, error = GrammarOperations.compile_shared_library_async(temporary_directory, language).receive
        return BoolResult.failure(error || "cc compilation failed", {"language" => language}) unless compiled

        BoolResult.success
      rescue ex
        BoolResult.failure("git/cc installer error: #{ex.message}", {"language" => language})
      end

      def create_manifest(language : String, temporary_directory : String) : GrammarMetadata
        commit = IO::Memory.new
        status = Process.run("git", ["rev-parse", "HEAD"], chdir: temporary_directory, output: commit, error: Process::Redirect::Pipe)
        GrammarMetadata.new(
          url: repository_url_for(language),
          type: "cc",
          commit_hash: status.success? ? commit.to_s.strip : nil,
          git_branch: branch_for(language),
          package_name: LanguageRegistry.package_name(language) || "tree-sitter-#{language}",
          language: language,
          installed_at: Time.utc,
          last_updated: Time.utc,
        )
      end

      private def repository_url_for(language : String) : String
        @repository_url || LanguageRegistry.git_url_for(language) || "https://github.com/tree-sitter/#{LanguageRegistry.package_name(language) || "tree-sitter-#{language}"}.git"
      end

      private def pinned_revision_for(language : String) : String?
        @revision || (@repository_url.nil? ? LanguageRegistry.git_revision_for(language) : nil)
      end

      private def branch_for(language : String) : String?
        @branch || (@repository_url.nil? ? LanguageRegistry.git_branch_for(language) : nil)
      end
    end
  end
end
