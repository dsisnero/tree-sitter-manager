require "toml"
require "./xdg"

module TreeSitterManager
  # Application configuration loaded from ~/.config/chiasmus/config.toml.
  # CLI flags override config values, which override defaults.
  struct AppConfig
    getter theme : String
    getter format : String
    getter cache_dir : String
    getter auto_install : Bool

    def initialize(
      @theme : String = "dracula::dracula",
      @format : String = "terminal",
      @cache_dir : String = XDG.grammar_cache_dir,
      @auto_install : Bool = true,
    )
    end
  end

  module Config
    extend self

    # Path to the config file
    def config_file : String
      File.join(XDG.chiasmus_config_dir, "config.toml")
    end

    # Load config from file, using defaults for missing values
    def load : AppConfig
      path = config_file
      from_file(path)
    end

    # Load config from a TOML file path
    def from_file(path : String) : AppConfig
      return AppConfig.new unless File.exists?(path)

      table = TOML.parse_file(path)
      AppConfig.new(
        theme: table["theme"]?.try(&.as_s?) || "dracula::dracula",
        format: table["format"]?.try(&.as_s?) || "terminal",
        cache_dir: table["cache_dir"]?.try(&.as_s?) || XDG.grammar_cache_dir,
        auto_install: table["auto_install"]?.try(&.as_bool?) != false,
      )
    rescue ex
      AppConfig.new
    end
  end
end
