module TreeSitterManager
  module VersionChecker
    # The exact Git source state to compare. `ref` is a named remote ref such
    # as `refs/heads/main`, never the ambiguous remote HEAD pseudoref.
    record GitVersion, repository : String, pinned_revision : String?, ref : String

    # The exact npm package state to compare.
    record NpmVersion, package : String, installed_version : String?

    alias Version = GitVersion | NpmVersion
  end
end
