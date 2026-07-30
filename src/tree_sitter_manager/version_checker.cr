require "./version_checker/version"
require "./version_checker/git"
require "./version_checker/npm"

module TreeSitterManager
  module VersionChecker
    def self.needs_update?(version : Version) : BoolResult
      case version
      when GitVersion
        Git.new.needs_update?(version)
      when NpmVersion
        Npm.new.needs_update?(version)
      else
        BoolResult.failure("Unsupported version checker input")
      end
    end
  end
end
