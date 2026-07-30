require "./base"

module TreeSitterManager
  module Installer
    # Builds a grammar supplied from a local directory without mutating it.
    class Local < Base
      def initialize(@source_directory : String, @tree_sitter_command : String = "tree-sitter")
      end

      def installation_method : Symbol
        :local
      end

      def download(language : String, temporary_directory : String) : BoolResult
        return BoolResult.failure("Local grammar directory does not exist", {"path" => @source_directory}) unless Dir.exists?(@source_directory)

        workspace = File.join(temporary_directory, File.basename(File.expand_path(@source_directory)))
        FileUtils.cp_r(@source_directory, workspace)
        generated = Process.run(@tree_sitter_command, ["generate"], chdir: workspace)
        return BoolResult.failure("tree-sitter generate failed", {"language" => language}) unless generated.success?
        built = Process.run(@tree_sitter_command, ["build"], chdir: workspace)
        return BoolResult.failure("tree-sitter build failed", {"language" => language}) unless built.success?
        BoolResult.success
      rescue ex
        BoolResult.failure("local installer error: #{ex.message}", {"language" => language})
      end

      def create_manifest(language : String, temporary_directory : String) : GrammarMetadata
        GrammarMetadata.new(url: @source_directory, type: "local", package_name: File.basename(@source_directory), language: language)
      end
    end
  end
end
