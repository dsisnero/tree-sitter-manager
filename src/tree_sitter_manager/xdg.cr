module TreeSitterManager
  # XDG Base Directory Specification utilities
  module XDG
    extend self

    APP_NAME = "tree-sitter-manager"

    # Get the XDG cache home.
    # XDG: $XDG_CACHE_HOME or ~/.cache
    def cache_home : String
      ENV["XDG_CACHE_HOME"]? || (Path.home / ".cache").to_s
    end

    # Get the XDG config home.
    # XDG: $XDG_CONFIG_HOME or ~/.config
    def config_home : String
      ENV["XDG_CONFIG_HOME"]? || (Path.home / ".config").to_s
    end

    # Get the XDG data home.
    # XDG: $XDG_DATA_HOME or ~/.local/share
    def data_home : String
      ENV["XDG_DATA_HOME"]? || (Path.home / ".local" / "share").to_s
    end

    # Get the XDG runtime directory.
    # XDG: $XDG_RUNTIME_DIR (no default, must be set)
    def runtime_dir : String?
      ENV["XDG_RUNTIME_DIR"]?
    end

    # Get the manager-specific cache directory.
    def manager_cache_dir : String
      File.join(cache_home, APP_NAME)
    end

    # Get the grammar cache directory.
    def grammar_cache_dir : String
      File.join(manager_cache_dir, "grammars")
    end

    # Get the manager-specific config directory.
    def manager_config_dir : String
      File.join(config_home, APP_NAME)
    end

    # Get the manager-specific data directory.
    def manager_data_dir : String
      File.join(data_home, APP_NAME)
    end

    # Get tree-sitter config directory (follows tree-sitter shard's logic)
    # Note: tree-sitter uses platform-specific defaults, not pure XDG
    def tree_sitter_config_dir : String
      # tree-sitter shard logic: XDG_CONFIG_HOME if set, otherwise platform default
      if xdg_config = ENV["XDG_CONFIG_HOME"]?
        xdg_config
      else
        {% if flag?(:darwin) %}
          # macOS: ~/Library/Application Support
          (Path.home / "Library" / "Application Support").to_s
        {% else %}
          # Linux/Unix: ~/.config
          (Path.home / ".config").to_s
        {% end %}
      end
    end

    # Get tree-sitter config file path
    def tree_sitter_config_file : String
      File.join(tree_sitter_config_dir, "tree-sitter", "config.json")
    end

    # Ensure all manager directories exist.
    def ensure_directories
      Dir.mkdir_p(grammar_cache_dir)
      Dir.mkdir_p(manager_config_dir)
      Dir.mkdir_p(manager_data_dir)

      # Also ensure tree-sitter config directory exists
      tree_sitter_dir = File.join(tree_sitter_config_dir, "tree-sitter")
      Dir.mkdir_p(tree_sitter_dir)
    end

    # Clear the manager cache.
    def clear_cache
      return unless Dir.exists?(manager_cache_dir)
      FileUtils.rm_rf(manager_cache_dir)
    end

    # Get state directory (for things that should persist but aren't config or cache)
    # XDG: $XDG_STATE_HOME or ~/.local/state
    def state_home : String
      ENV["XDG_STATE_HOME"]? || (Path.home / ".local" / "state").to_s
    end

    def manager_state_dir : String
      File.join(state_home, APP_NAME)
    end

    # Compatibility aliases for applications that used the manager while it
    # was embedded in Chiasmus. New code must use the manager_* names.
    def chiasmus_cache_dir : String
      manager_cache_dir
    end

    def chiasmus_config_dir : String
      manager_config_dir
    end

    def chiasmus_data_dir : String
      manager_data_dir
    end

    def chiasmus_state_dir : String
      manager_state_dir
    end
  end
end
