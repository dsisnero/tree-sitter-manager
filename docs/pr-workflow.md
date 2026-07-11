# PR Workflow

## Commits

Format: `<type>(<scope>): <description>`

Types: feat, fix, docs, refactor, test, chore, perf

Examples:
- `feat(tui): add theme search with prefix matching`
- `fix(renderer): capture compiler stderr on compile failure`
- `test(batch): add parallel installation level resolution tests`

## Branch Naming

`<type>/<description>`

Examples:
- `feat/theme-search`
- `fix/compiler-stderr-capture`
- `test/parallel-install-levels`

## Review Process

1. Run all gates before requesting review.
2. Keep PRs focused on a single concern.
3. Reference issues in the PR description.
