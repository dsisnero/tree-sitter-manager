# tree-sitter-manager

CLI + TUI tool for managing tree-sitter grammars, queries, and syntax highlighting.

## Commands

```bash
shards install          # Install dependencies
shards update           # Update dependencies
crystal tool format src spec bin  # Format Crystal source
ameba src spec bin      # Lint
crystal spec            # Run tests
shards build            # Build both binaries (tree-sitter-manager, tsm-tui)
```

## Documentation

| Document | Purpose |
|----------|---------|
| [Architecture](docs/architecture.md) | System design, data flow, package responsibilities |
| [Development](docs/development.md) | Prerequisites, setup, daily workflow |
| [Coding Guidelines](docs/coding-guidelines.md) | Code style, error handling, naming conventions |
| [Testing](docs/testing.md) | Test commands, conventions, patterns |
| [PR Workflow](docs/pr-workflow.md) | Commits, PRs, branch naming, review process |

## Core Principles

1. **Syntastica parity** — theme data and renderer output must match the upstream Rust syntastica library byte-for-byte.
2. **Red-green TDD** — write a failing test first, then implement, then verify.
3. **Async by default** — grammar operations use fibers + channels; never block the event loop.
4. **Stderr never discarded** — all subprocess errors (git, cc, tree-sitter) are captured and surfaced with context.

## Commit Message Convention

`<type>(<scope>): <description>`

Types: feat, fix, docs, refactor, test, chore, perf

Examples:
- `feat(tui): add theme search with prefix matching`
- `fix(renderer): capture compiler stderr on compile failure`
- `test(batch): add parallel installation level resolution tests`

## Project Conventions

- Two entry points: `src/tree-sitter-manager.cr` (CLI) and `src/tsm-tui.cr` (TUI)
- TUI uses Bubble Tea (`Tea::Model`) + Bubbles components
- `Tea::KeyPressMsg` is `Tea::Key`, not `Tea::KeyMsg` — match with `when Tea::KeyPressMsg`
- Crystal does not allow `if cond && var = expr` — split into `if cond` then `var = expr`
- Temporary files go in `./temp/`
