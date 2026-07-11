# Architecture

## Overview

`tree-sitter-manager` has two entry points:

- **CLI** (`src/tree-sitter-manager.cr`): subcommand-based interface using the `clip` library
- **TUI** (`src/tsm-tui.cr`): interactive terminal UI using `bubbletea` (Crystal port of Bubble Tea)

Both share the same core library under `src/tree_sitter_manager/`.

## Package Layout

| Directory | Purpose |
|-----------|---------|
| `src/tree_sitter_manager/` | Core library (highlighting, themes, grammars, config) |
| `queries/` | Tree-sitter `.scm` query files per language |
| `vendor/syntastica/` | Upstream Rust syntastica (source-of-truth for themes) |
| `vendor/tree-sitter-language-pack/` | Language definitions |
| `lib/` | Crystal shard dependencies |
| `languages.toml` | Primary language definitions (66 languages) |

## Data Flow

```
Source file → LanguageDetection → SourceHighlighter → GrammarLoader → TreeSitter::Parser
                                                          ↓
                                              GrammarManager (install if missing)
                                                          ↓
                                              Span merging → Theme resolution → Renderer → ANSI/HTML
```

## Key Modules

- **SourceHighlighter** — orchestrates parsing, querying, and rendering
- **GrammarManager** — singleton for async grammar acquisition (clone, compile, cache)
- **GrammarLoader** — finds and loads `.so`/`.dylib` via dlopen
- **LanguageRegistry** — metadata for 306+ languages
- **Themes** — 64 theme variants ported from syntastica
- **Config** — TOML config from `~/.config/chiasmus/config.toml`
