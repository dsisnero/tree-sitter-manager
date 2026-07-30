require "./version"

module TreeSitterManager
  module VersionChecker
    class Git
      def initialize(@git_command : String = "git")
      end

      def needs_update?(version : GitVersion) : BoolResult
        return BoolResult.failure("No URL for git grammar") if version.repository.empty?
        output = IO::Memory.new
        target = version.branch || "HEAD"
        status = Process.run(@git_command, ["ls-remote", version.repository, target], output: output, error: Process::Redirect::Pipe)
        return BoolResult.failure("Failed to check git repository", {"repository" => version.repository, "branch" => target}) unless status.success?

        latest_version = output.to_s.split.first?
        unless latest_version
          return BoolResult.failure("Git repository has no commit for branch", {"repository" => version.repository, "branch" => target})
        end

        changed = !version.pinned_revision.nil? && latest_version != version.pinned_revision
        BoolResult.new(value: changed, details: {"repository" => version.repository, "branch" => target, "pinned_revision" => version.pinned_revision.to_s, "latest_revision" => latest_version})
      rescue ex
        BoolResult.failure("Error checking git updates: #{ex.message}", {"repository" => version.repository})
      end
    end
  end
end
