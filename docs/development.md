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
crystal tool format src spec bin
ameba src spec bin
crystal spec
shards build
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
crystal spec              # Full suite
crystal spec spec/path    # Single file
crystal spec spec/path:12 # Single example
```

## Temporary Files

All temporary artifacts go in `./temp/`. This directory is gitignored.
