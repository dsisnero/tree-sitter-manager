require "dir-walk"

module TreeSitterManager
  # Directory traversal helpers backed by dir-walk.
  module DirectoryWalker
    extend self

    # Returns names directly beneath `root`, without exposing descendants.
    def children(root : String) : Array(String)
      return [] of String unless Dir.exists?(root)

      expanded_root = File.expand_path(root)
      children = [] of String
      discovered = Channel(String).new
      completed = Channel(Nil).new(1)

      spawn do
        begin
          config = Dir::Walk::Config.new(max_depth: 1, num_workers: 1)
          Dir::Walk.walk(config, expanded_root) do |path, entry, error|
            next if error || !entry
            expanded_path = File.expand_path(path)
            if File.dirname(expanded_path) == expanded_root
              discovered.send(File.basename(expanded_path))
            end
          end
        ensure
          discovered.close
          completed.send(nil)
        end
      end

      while child = discovered.receive?
        children << child
      end
      completed.receive

      children.sort!
    end

    # Returns files beneath `root`, optionally limited to names ending with
    # `suffix`. Results are sorted for deterministic callers and tests.
    def files(root : String, suffix : String? = nil) : Array(String)
      return [] of String unless Dir.exists?(root)

      matches = [] of String
      discovered = Channel(String).new
      completed = Channel(Nil).new(1)

      spawn do
        begin
          Dir::Walk.walk(nil, root) do |path, entry, error|
            next if error || !entry || !entry.file?
            discovered.send(path) if suffix.nil? || path.ends_with?(suffix)
          end
        ensure
          discovered.close
          completed.send(nil)
        end
      end

      while path = discovered.receive?
        matches << path
      end
      completed.receive

      matches.sort!
    end
  end
end
