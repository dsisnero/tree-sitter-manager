# Architecture

## Overview

`tree-sitter-manager` has two entry points:

- **CLI** (`src/tree-sitter-manager.cr`): subcommand-based interface using the `clip` library. Commands: highlight, themes, languages, queries, stats, groups, version, doctor, completions.
- **TUI** (`src/tsm-tui.cr`): interactive terminal UI using `bubbletea` (Crystal port of Bubble Tea) with viewport, file picker, help bar, theme browser, and spinner.

Both share the same core library under `src/tree_sitter_manager/`.

## Package Layout

| Directory | Purpose |
|-----------|---------|
| `src/tree_sitter_manager/` | Core library (highlighting, themes, grammars, config, CLI, TUI) |
| `queries/` | Tree-sitter `.scm` query files per language (69 languages) |
| `vendor/syntastica/` | Upstream Rust syntastica (source-of-truth for themes and queries) |
| `vendor/tree-sitter-language-pack/` | Language definitions (306 languages) |
| `spec/` | Crystal specs (394 examples) |
| `languages.toml` | Primary language definitions (66 languages with git URLs, revs, file-types) |
| `scripts/generate_language_registry.cr` | Generates `language_registry_generated.cr` from JSON + TOML |

## Data Flow

```
Source file → LanguageDetection → SourceHighlighter
                                        ↓
                              GrammarLoader (find .so)
                                        ↓
                        ┌─ Found? ─→ TreeSitter::Parser
                        │
                        └─ Missing? → GrammarManager
                                        ↓
                              git clone → cc compile → cache .so
                                        ↓
                              GrammarLoader (load .so)
                                        ↓
                        TreeSitter::Parser → parse source
                                        ↓
                        QueryManager → build combined query
                                        ↓
                        QueryCursor → execute → captures
                                        ↓
                        Span merging → theme resolution
                                        ↓
                        TerminalRenderer → ANSI output
```

## Key Modules

| Module | Responsibility |
|--------|---------------|
| **SourceHighlighter** | Orchestrates parsing, querying, and rendering |
| **GrammarManager** | Singleton for async grammar acquisition (clone, compile, cache) with fiber-based concurrency |
| **GrammarLoader** | Finds and loads `.so`/`.dylib` via dlopen |
| **LanguageRegistry** | Metadata for 306+ languages (extensions, git URLs, dependencies) |
| **Themes** | 64 theme variants across 29 families, ported from syntastica with byte-identical color data |
| **Config** | TOML config from `~/.config/chiasmus/config.toml` |
| **TerminalRenderer** | ANSI true-color output with theme background fill |
| **GrammarBatchOperations** | Parallel installation using Worker Pool pattern (MAX_WORKERS=4) |

## Concurrency

All grammar operations use Crystal fibers + channels:

- `ensure_grammar_async` → `Channel(BoolResult)` — non-blocking
- `install_level` → Worker Pool with `WaitGroup` — parallel within dependency-safe levels
- `retry_with_backoff` → exponential backoff on transient failures (git clone)
- `GrammarManager` deduplicates concurrent `ensure_grammar` calls for the same language
