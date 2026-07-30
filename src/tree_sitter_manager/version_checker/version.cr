module TreeSitterManager
  module VersionChecker
    # The exact Git source state to compare. `branch` is the optional source
    # branch from the language definition; absent means remote HEAD.
    record GitVersion, repository : String, pinned_revision : String?, branch : String?

    # The exact npm package state to compare.
    record NpmVersion, package : String, installed_version : String?

    alias Version = GitVersion | NpmVersion
  end
end
