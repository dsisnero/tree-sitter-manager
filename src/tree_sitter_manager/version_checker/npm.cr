require "./version"

module TreeSitterManager
  module VersionChecker
    class Npm
      def initialize(@npm_command : String = "npm")
      end

      def needs_update?(version : NpmVersion) : BoolResult
        return BoolResult.failure("No package name for npm grammar") if version.package.empty?

        output = IO::Memory.new
        status = Process.run(@npm_command, ["view", version.package, "version"], output: output, error: Process::Redirect::Pipe)
        unless status.success?
          output = IO::Memory.new
          status = Process.run(@npm_command, ["view", version.package, "version", "--json"], output: output, error: Process::Redirect::Pipe)
          return BoolResult.failure("Failed to check npm registry", {"package" => version.package}) unless status.success?
        end

        latest_version = output.to_s.strip.gsub(/^"|"$/, "")
        changed = !version.installed_version.nil? && latest_version != version.installed_version
        BoolResult.new(value: changed, details: {"package" => version.package, "installed_version" => version.installed_version.to_s, "latest_version" => latest_version})
      rescue ex
        BoolResult.failure("Error checking npm updates: #{ex.message}", {"package" => version.package})
      end
    end
  end
end
