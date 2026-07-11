# tree-sitter-manager

CLI + TUI tool for managing tree-sitter grammars, queries, and syntax highlighting.

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

### CLI

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

### Configuration

`~/.config/chiasmus/config.toml`:

```toml
theme = "nord::nord"
format = "terminal"
auto_install = true
```

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
shards build          # Build both binaries
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
