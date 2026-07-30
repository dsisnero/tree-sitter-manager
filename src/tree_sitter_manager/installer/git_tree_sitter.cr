require "./base"
require "../language_registry"

module TreeSitterManager
  module Installer
    # Clones a grammar repository and delegates generation/building to the
    # tree-sitter CLI in the isolated installer workspace.
    class GitTreeSitter < Base
      def installation_method : Symbol
        :git
      end

      def initialize(@repository_url : String? = nil, @revision : String? = nil, @tree_sitter_command : String = "tree-sitter")
      end

      def download(language : String, temporary_directory : String) : BoolResult
        repository = repository_url_for(language)
        clone_args = ["clone"] of String
        clone_args.concat(["--depth", "1"]) unless pinned_revision_for(language)
        clone_args.concat([repository, "."])
        clone = Process.run("git", clone_args, chdir: temporary_directory)
        return BoolResult.failure("git clone failed", {"language" => language}) unless clone.success?

        if revision = pinned_revision_for(language)
          checkout = Process.run("git", ["checkout", "--detach", revision], chdir: temporary_directory, error: Process::Redirect::Pipe)
          return BoolResult.failure("git checkout pinned revision failed", {"language" => language, "revision" => revision}) unless checkout.success?
        end

        generate = Process.run(@tree_sitter_command, ["generate"], chdir: temporary_directory)
        return BoolResult.failure("tree-sitter generate failed", {"language" => language}) unless generate.success?

        build = Process.run(@tree_sitter_command, ["build"], chdir: temporary_directory)
        return BoolResult.failure("tree-sitter build failed", {"language" => language}) unless build.success?

        BoolResult.success
      rescue ex
        BoolResult.failure("git/tree-sitter installer error: #{ex.message}", {"language" => language})
      end

      def create_manifest(language : String, temporary_directory : String) : GrammarMetadata
        commit = IO::Memory.new
        status = Process.run("git", ["rev-parse", "HEAD"], chdir: temporary_directory, output: commit, error: Process::Redirect::Pipe)
        GrammarMetadata.new(url: repository_url_for(language), type: "tree-sitter", commit_hash: status.success? ? commit.to_s.strip : nil, git_ref: remote_head_ref(temporary_directory), package_name: LanguageRegistry.package_name(language) || "tree-sitter-#{language}", language: language)
      end

      private def repository_url_for(language : String) : String
        @repository_url || LanguageRegistry.git_url_for(language) || "https://github.com/tree-sitter/tree-sitter-#{language}.git"
      end

      private def pinned_revision_for(language : String) : String?
        @revision || (@repository_url.nil? ? LanguageRegistry.git_revision_for(language) : nil)
      end

      private def remote_head_ref(directory : String) : String?
        output = IO::Memory.new
        status = Process.run("git", ["symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD"], chdir: directory, output: output, error: Process::Redirect::Pipe)
        return nil unless status.success?
        branch = output.to_s.strip.sub(/^origin\//, "")
        branch.empty? ? nil : "refs/heads/#{branch}"
      end
    end
  end
end
