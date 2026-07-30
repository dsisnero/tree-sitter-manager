require "./version"

module TreeSitterManager
  module VersionChecker
    class Git
      def initialize(@git_command : String = "git")
      end

      def needs_update?(version : GitVersion) : BoolResult
        return BoolResult.failure("No URL for git grammar") if version.repository.empty?
        return BoolResult.failure("No ref for git grammar") if version.ref.empty?

        output = IO::Memory.new
        status = Process.run(@git_command, ["ls-remote", version.repository, version.ref], output: output, error: Process::Redirect::Pipe)
        return BoolResult.failure("Failed to check git repository", {"repository" => version.repository, "ref" => version.ref}) unless status.success?

        latest_version = output.to_s.split.first?
        unless latest_version
          return BoolResult.failure("Git repository has no commit for ref", {"repository" => version.repository, "ref" => version.ref})
        end

        changed = !version.pinned_revision.nil? && latest_version != version.pinned_revision
        BoolResult.new(value: changed, details: {"repository" => version.repository, "ref" => version.ref, "pinned_revision" => version.pinned_revision.to_s, "latest_revision" => latest_version})
      rescue ex
        BoolResult.failure("Error checking git updates: #{ex.message}", {"repository" => version.repository})
      end

      # Resolves legacy metadata to a stable named branch before a comparison.
      def default_ref_for(repository : String) : StringResult
        return StringResult.new(error: "No URL for git grammar") if repository.empty?

        output = IO::Memory.new
        status = Process.run(@git_command, ["ls-remote", "--symref", repository, "HEAD"], output: output, error: Process::Redirect::Pipe)
        return StringResult.new(error: "Failed to resolve git default ref", details: {"repository" => repository}) unless status.success?

        ref = output.to_s.lines.find(&.starts_with?("ref: ")).try(&.split[1]?)
        return StringResult.new(error: "Git repository has no symbolic HEAD", details: {"repository" => repository}) unless ref

        StringResult.new(value: ref)
      rescue ex
        StringResult.new(error: "Error resolving git default ref: #{ex.message}", details: {"repository" => repository})
      end
    end
  end
end
