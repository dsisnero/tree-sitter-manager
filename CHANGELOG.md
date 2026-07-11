# Changelog

## 0.1.0 (2026-07-11)

### Features

- **TUI**: Interactive syntax highlighter with bubbletea — viewport scrolling, help bar, status line, file picker (Ctrl+o), theme browser with preview swatch and prefix search (/)
- **CLI**: Subcommands for highlight, themes, languages, queries, stats, groups, version, doctor, completions
- **Grammar management**: Async install via git clone + cc compile, parallel installation (Worker Pool, MAX_WORKERS=4), retry with exponential backoff, stderr capture
- **Auto-install**: Missing grammars installed automatically on highlight with spinner animation in TUI
- **Themes**: 64 theme variants across 29 families, ported from syntastica with byte-identical color data
- **Config**: TOML config at `~/.config/chiasmus/config.toml` (theme, format, cache_dir, auto_install)
- **Shell completions**: `tree-sitter-manager completions bash|zsh|fish`
- **Language detection**: Content-based extension tiebreaking, shebang/vim modeline/Emacs detection

### Fixed

- All theme `_normal` entries were missing background colors — now match syntastica exactly
- Terminal renderer now applies theme background to all text (including unstyled segments)
- Compiler stderr was discarded in `compile_sources` — now captured and surfaced
- Git clone and tree-sitter generate stderr were discarded — now captured
- File picker directory navigation was broken (command from `fp.update` was discarded)
- File picker showed only one line (no WindowSizeMsg was sent to it)
- Ctrl+o key matching was wrong (raw byte value instead of UV-decoded code)
