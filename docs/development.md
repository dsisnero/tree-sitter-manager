# Development

## Prerequisites

- Crystal >= 1.19.1
- cc (or gcc) — for compiling tree-sitter grammars
- git — for cloning grammar repositories
- tree-sitter CLI (optional) — for generating parsers from grammar definitions

## Setup

```bash
shards install
```

## Daily Workflow

```bash
# Make changes, then:
crystal tool format src spec bin  # Format
ameba src spec bin                 # Lint
crystal spec                       # Test
shards build                       # Build binaries (tree-sitter-manager, tsm-tui)
```

## Running

```bash
# CLI
./bin/tree-sitter-manager highlight file.cr --theme dracula::dracula

# TUI
./bin/tsm-tui file.cr
```

## Testing

```bash
crystal spec              # Full suite (394+ examples)
crystal spec spec/path    # Single file
crystal spec spec/path:12 # Single example at line 12
```

## Project Structure

```
src/
  tree-sitter-manager.cr           # Library entry + CLI auto-run
  tsm-tui.cr                       # TUI entry point
  tree_sitter_manager/
    cli.cr                         # CLI subcommands
    tui.cr                         # TUI model
    tui_app.cr                     # Bubble Tea app
    source_highlighter.cr          # Highlighting pipeline
    grammar_manager.cr             # Grammar install orchestration
    grammar_loader.cr              # .so/.dylib loading via dlopen
    grammar_batch_operations.cr    # Parallel batch install
    grammar_operations.cr          # Low-level git/cc/npm ops
    grammar_metadata.cr            # Installed grammar tracking
    renderers.cr                   # Terminal and HTML renderers
    themes.cr                      # Theme registry
    theme.cr                       # Theme resolution
    themes/*.cr                    # 29 theme family files
    config.cr                      # TOML config support
    language_registry.cr           # Language metadata
    language_detection.cr          # Shebang/modeline detection
    query_manager.cr               # Query loading and preprocessing
    highlight_configuration.cr     # Query capture → theme key mapping
    highlight_keys.cr              # Canonical theme key names
    xdg.cr                         # XDG directory paths
    result.cr                      # Result types (BoolResult, etc.)
    platform.cr                    # OS detection
    download_manager.cr            # Pre-built binary download (scaffold)
    embedded_grammars.cr           # Pre-built grammars in binary
    language_loader.cr             # Vendor grammar fallback
```

## Temporary Files

All temporary artifacts go in `./temp/`. This directory is gitignored.
