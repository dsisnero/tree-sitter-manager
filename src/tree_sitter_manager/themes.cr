require "./themes/abscs"
require "./themes/aurora"
require "./themes/blue_moon"
require "./themes/boo"
require "./themes/catppuccin"
require "./themes/darcula"
require "./themes/dracula"
require "./themes/everblush"
require "./themes/everforest"
require "./themes/falcon"
require "./themes/github"
require "./themes/gruvbox"
require "./themes/melange"
require "./themes/minimal"
require "./themes/monochrome"
require "./themes/monokai"
require "./themes/moonfly"
require "./themes/moonlight"
require "./themes/neon"
require "./themes/nightfly"
require "./themes/nord"
require "./themes/oceanicnext"
require "./themes/omni"
require "./themes/one"
require "./themes/oxocarbon"
require "./themes/solarized"
require "./themes/tokyo"
require "./themes/vscode"
require "./themes/zephyr"

module TreeSitterManager
  module Themes
    extend self

    # All theme names in "family::variant" format (ported from syntastica)
    THEMES = [
      "abscs::abscs",
      "aurora::aurora",
      "blue_moon::blue_moon",
      "boo::boo",
      "catppuccin::frappe",
      "catppuccin::latte",
      "catppuccin::macchiato",
      "catppuccin::mocha",
      "darcula::darcula",
      "dracula::dracula",
      "everblush::everblush",
      "everforest::dark",
      "everforest::light",
      "falcon::falcon",
      "github::dark",
      "github::dark_colorblind",
      "github::dark_default",
      "github::dark_dimmed",
      "github::dark_high_contrast",
      "github::dark_tritanopia",
      "github::light",
      "github::light_colorblind",
      "github::light_default",
      "github::light_high_contrast",
      "github::light_tritanopia",
      "gruvbox::dark",
      "gruvbox::light",
      "melange::melange",
      "minimal::minimal",
      "monochrome::monochrome",
      "monokai::monokai",
      "monokai::pro",
      "monokai::ristretto",
      "monokai::soda",
      "moonfly::moonfly",
      "moonlight::moonlight",
      "neon::dark",
      "neon::default",
      "neon::doom",
      "neon::light",
      "nightfly::nightfly",
      "nord::nord",
      "oceanicnext::dark",
      "oceanicnext::light",
      "omni::omni",
      "one::cool",
      "one::dark",
      "one::darker",
      "one::deep",
      "one::light",
      "one::warm",
      "one::warmer",
      "oxocarbon::dark",
      "oxocarbon::light",
      "solarized::dark",
      "solarized::light",
      "tokyo::day",
      "tokyo::moon",
      "tokyo::night",
      "tokyo::storm",
      "vscode::dark",
      "vscode::light",
      "zephyr::zephyr",
    ]

    # Try to get a theme by "family::variant" name string.
    # Returns nil if not found.
    def from_str(name : String) : ResolvedTheme?
      case name
      when "abscs::abscs"                then abscs_abscs
      when "aurora::aurora"              then aurora_aurora
      when "blue_moon::blue_moon"        then blue_moon_blue_moon
      when "boo::boo"                    then boo_boo
      when "catppuccin::frappe"          then catppuccin_frappe
      when "catppuccin::latte"           then catppuccin_latte
      when "catppuccin::macchiato"       then catppuccin_macchiato
      when "catppuccin::mocha"           then catppuccin_mocha
      when "darcula::darcula"            then darcula_darcula
      when "dracula::dracula"            then dracula_dracula
      when "everblush::everblush"        then everblush_everblush
      when "everforest::dark"            then everforest_dark
      when "everforest::light"           then everforest_light
      when "falcon::falcon"              then falcon_falcon
      when "github::dark"                then github_dark
      when "github::dark_colorblind"     then github_dark_colorblind
      when "github::dark_default"        then github_dark_default
      when "github::dark_dimmed"         then github_dark_dimmed
      when "github::dark_high_contrast"  then github_dark_high_contrast
      when "github::dark_tritanopia"     then github_dark_tritanopia
      when "github::light"               then github_light
      when "github::light_colorblind"    then github_light_colorblind
      when "github::light_default"       then github_light_default
      when "github::light_high_contrast" then github_light_high_contrast
      when "github::light_tritanopia"    then github_light_tritanopia
      when "gruvbox::dark"               then gruvbox_dark
      when "gruvbox::light"              then gruvbox_light
      when "melange::melange"            then melange_melange
      when "minimal::minimal"            then minimal_minimal
      when "monochrome::monochrome"      then monochrome_monochrome
      when "monokai::monokai"            then monokai_monokai
      when "monokai::pro"                then monokai_pro
      when "monokai::ristretto"          then monokai_ristretto
      when "monokai::soda"               then monokai_soda
      when "moonfly::moonfly"            then moonfly_moonfly
      when "moonlight::moonlight"        then moonlight_moonlight
      when "neon::dark"                  then neon_dark
      when "neon::default"               then neon_default
      when "neon::doom"                  then neon_doom
      when "neon::light"                 then neon_light
      when "nightfly::nightfly"          then nightfly_nightfly
      when "nord::nord"                  then nord_nord
      when "oceanicnext::dark"           then oceanicnext_dark
      when "oceanicnext::light"          then oceanicnext_light
      when "omni::omni"                  then omni_omni
      when "one::cool"                   then one_cool
      when "one::dark"                   then one_dark
      when "one::darker"                 then one_darker
      when "one::deep"                   then one_deep
      when "one::light"                  then one_light
      when "one::warm"                   then one_warm
      when "one::warmer"                 then one_warmer
      when "oxocarbon::dark"             then oxocarbon_dark
      when "oxocarbon::light"            then oxocarbon_light
      when "solarized::dark"             then solarized_dark
      when "solarized::light"            then solarized_light
      when "tokyo::day"                  then tokyo_day
      when "tokyo::moon"                 then tokyo_moon
      when "tokyo::night"                then tokyo_night
      when "tokyo::storm"                then tokyo_storm
      when "vscode::dark"                then vscode_dark
      when "vscode::light"               then vscode_light
      when "zephyr::zephyr"              then zephyr_zephyr
      end
    end

    # Legacy: list available short theme names (backward compatible)
    def available : Array(String)
      %w[dracula nord catppuccin_mocha github_light]
    end

    # Legacy: get a theme by short name (backward compatible)
    def get(name : String) : ResolvedTheme?
      case name
      when "dracula"          then dracula
      when "nord"             then nord
      when "catppuccin_mocha" then catppuccin_mocha
      when "github_light"     then github_light
      when "tokyo_storm"      then tokyo_storm
      end
    end

    # Backward-compatible aliases for original 4 themes
    def dracula : ResolvedTheme
      dracula_dracula
    end

    def nord : ResolvedTheme
      nord_nord
    end
  end
end
