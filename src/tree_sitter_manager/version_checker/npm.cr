require "./base"

module TreeSitterManager
  module VersionChecker
    class Npm < Base
      def initialize(@npm_command : String = "npm")
      end

      def needs_update?(identifier : String, current_version : String?) : BoolResult
        return BoolResult.failure("No package name for npm grammar") if identifier.empty?

        output = IO::Memory.new
        status = Process.run(@npm_command, ["view", identifier, "version"], output: output, error: Process::Redirect::Pipe)
        unless status.success?
          output = IO::Memory.new
          status = Process.run(@npm_command, ["view", identifier, "version", "--json"], output: output, error: Process::Redirect::Pipe)
          return BoolResult.failure("Failed to check npm registry", {"package" => identifier}) unless status.success?
        end

        latest_version = output.to_s.strip.gsub(/^"|"$/, "")
        changed = !current_version.nil? && latest_version != current_version
        BoolResult.new(value: changed, details: {"identifier" => identifier, "current_version" => current_version.to_s, "latest_version" => latest_version})
      rescue ex
        BoolResult.failure("Error checking npm updates: #{ex.message}", {"package" => identifier})
      end
    end
  end
end
