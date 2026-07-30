require "../result"

module TreeSitterManager
  module VersionChecker
    abstract class Base
      abstract def needs_update?(identifier : String, current_version : String?) : BoolResult
    end
  end
end
