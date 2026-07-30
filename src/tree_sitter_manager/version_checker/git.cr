require "./base"

module TreeSitterManager
  module VersionChecker
    class Git < Base
      def initialize(@git_command : String = "git")
      end

      def needs_update?(identifier : String, current_version : String?) : BoolResult
        return BoolResult.failure("No URL for git grammar") if identifier.empty?

        output = IO::Memory.new
        status = Process.run(@git_command, ["ls-remote", identifier, "HEAD"], output: output, error: Process::Redirect::Pipe)
        return BoolResult.failure("Failed to check git repository", {"identifier" => identifier}) unless status.success?

        latest_version = output.to_s.split.first?
        unless latest_version
          return BoolResult.failure("Git repository has no HEAD commit", {"identifier" => identifier})
        end

        changed = !current_version.nil? && latest_version != current_version
        BoolResult.new(value: changed, details: {"identifier" => identifier, "current_version" => current_version.to_s, "latest_version" => latest_version})
      rescue ex
        BoolResult.failure("Error checking git updates: #{ex.message}", {"identifier" => identifier})
      end
    end
  end
end
