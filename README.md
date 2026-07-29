# tree-sitter-manager

Reusable Crystal runtime for Tree-sitter grammar discovery, installation,
loading, parsing, and cache management.

The command-line interface, TUI, highlighting, themes, and renderers live in
the companion `tree-sitter-manager-cli` application. Keeping them separate
means applications such as Chiasmus can use grammar management without pulling
in terminal UI dependencies.

[![Crystal](https://img.shields.io/badge/crystal-%3E%3D1.19.1-1f1f1f)](https://crystal-lang.org)

## Installation

Add the dependency to your `shard.yml`:

```yaml
dependencies:
  tree-sitter-manager:
    github: dsisnero/tree-sitter-manager
```

Run `shards install`.

## Usage

### Library

```crystal
require "tree-sitter-manager"

TreeSitterManager::GrammarManager.init
result = TreeSitterManager::GrammarManager.instance.ensure_grammar_async("crystal").receive
```

The public entry point intentionally exposes only the reusable runtime. It has
no CLI, TUI, theme, renderer, or highlighting dependencies.

### CLI and TUI

Install or develop the companion `tree-sitter-manager-cli` application for the
interactive commands and syntax-highlighting interface.

```bash
# Highlight a file
tree-sitter-manager highlight file.cr

# With a specific theme and format
tree-sitter-manager highlight file.cr --theme nord::nord --format html

# List themes, languages, queries
tree-sitter-manager themes
tree-sitter-manager languages
tree-sitter-manager queries crystal

# Stats and diagnostics
tree-sitter-manager stats
tree-sitter-manager doctor

# Generate shell completions
tree-sitter-manager completions bash > /etc/bash_completion.d/tree-sitter-manager
```

### TUI

```bash
tsm-tui              # Opens file picker
tsm-tui file.cr      # Opens file directly
```

Key bindings: `q` quit, `t/T` cycle theme, `/` search theme, `↑/↓` scroll, `Ctrl+o` open file, `?` toggle help.

### Runtime storage

The core uses standard XDG locations under `tree-sitter-manager`, for example
`~/.cache/tree-sitter-manager/grammars`.

The CLI application owns its presentation configuration.

The companion CLI owns its own presentation configuration and query assets.

## Documentation

| Document | Purpose |
|----------|---------|
| [Architecture](docs/architecture.md) | System design, data flow, package responsibilities |
| [Development](docs/development.md) | Prerequisites, setup, daily workflow |
| [Coding Guidelines](docs/coding-guidelines.md) | Code style, error handling, naming conventions |
| [Testing](docs/testing.md) | Test commands, conventions, patterns |
| [PR Workflow](docs/pr-workflow.md) | Commits, PRs, branch naming, review process |

## Development

```bash
shards install
shards build          # Build the core verification target
crystal spec          # Run tests
crystal tool format   # Format code
ameba src spec bin    # Lint
```

## Contributing

1. Fork it (<https://github.com/dsisnero/tree-sitter-manager/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT

## Contributors

- [Dominic Sisneros](https://github.com/dsisnero) — creator and maintainer
