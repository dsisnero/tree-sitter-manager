module TreeSitterManager
  # Manages pre-built parser shared libraries downloaded from GitHub releases.
  # Ported from tree-sitter-language-pack download.rs.
  #
  # Libraries are cached in `~/.cache/tree-sitter-manager/libs/` by default.
  # The cache is automatically registered with GrammarLoader.
  class DownloadManager
    getter cache_dir : String

    # Default cache directory — XDG cache + app name + version + libs.
    def self.default_cache_dir : String
      xdg = ENV["XDG_CACHE_HOME"]? || File.join(ENV["HOME"]? || "/tmp", ".cache")
      File.join(xdg, "tree-sitter-manager", "libs")
    end

    def initialize(@cache_dir : String = self.class.default_cache_dir)
      Dir.mkdir_p(@cache_dir)
    end

    # Register the cache directory with GrammarLoader so it's searched for shared libraries.
    def register_with_loader : Nil
      GrammarLoader.register_grammar_directory(@cache_dir)
    end

    # Scan the cache directory and return language names for which shared libraries exist.
    # Parses filenames like `libtree-sitter-python.so` → `"python"`.
    def installed_languages : Array(String)
      return [] of String unless Dir.exists?(@cache_dir)

      languages = [] of String
      Dir.children(@cache_dir).each do |entry|
        next unless entry.ends_with?(".so") || entry.ends_with?(".dylib") || entry.ends_with?(".dll")

        # Extract language name from libtree-sitter-<name>.<ext>
        name = entry
          .sub(/^lib/, "")
          .sub(/\.(so|dylib|dll)$/, "")
        if name.starts_with?("tree-sitter-") || name.starts_with?("tree_sitter-")
          name = name.sub(/^tree.sitter./, "")
        end
        languages << name unless languages.includes?(name)
      end
      languages
    end
  end
end
