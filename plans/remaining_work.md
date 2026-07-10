# Remaining Work

Feature-size tasks, ordered by impact. Check off as completed.

---

## TUI: Interactive Syntax Highlighter

### [x] TUI core — file highlighting with bubbletea
- Wire `tsm-tui` entry point into full bubbletea `Tea::Model`
- Render highlighted file content via viewport
- Key bindings: q=quit, t=cycle theme, T=cycle backward, ?=toggle help, ↑↓=scroll
- **Test**: `shards build tsm-tui` builds successfully

### [x] TUI file picker
- Integrate `Bubbles::Filepicker` component
- Open files from picker → highlight them
- Key: Ctrl+o to open picker, esc to close
- **Test**: opens on Ctrl+o, closes on esc, shows file entries

### [x] TUI theme browser
- Show theme name + preview swatch on theme change
- Show theme info in header on color change
- Jump to specific theme by name (`/` to search, type prefix, Enter/Esc to close)
- **Test**: swatch color in view, jump by prefix, search mode activate/deactivate

### [x] TUI help bar
- Show key bindings at bottom using `Bubbles::Help`
- Keys: q=quit, t/T=cycle theme, ↑↓=scroll, ?=toggle help
- **Test**: help bar visible, keys work

### [x] TUI status line
- Show current file path, language, theme info
- **Test**: status updates when opening files

---

## Grammar Management

### [ ] Download pre-built binaries from releases
- `DownloadManager#ensure_language(name)` fetches `.so` from GitHub
- `GrammarManager` uses download as first strategy, compile as fallback
- **Test**: `ensure_grammar("python")` downloads without compiling

### [ ] Grammar health check
- Verify installed grammars parse correctly
- Report ABI version mismatches
- `tree-sitter-manager doctor` subcommand
- **Test**: run on all installed grammars, report failures

### [x] Parallel grammar installation
- Worker Pool pattern: `MAX_WORKERS = 4` fibers process languages concurrently
- `resolve_dependency_levels` splits dependency graph into parallel-safe levels
- Levels processed sequentially; within each level, all languages install in parallel
- `check_missing_defaults_async` and `update_all_async` also use parallel workers
- Thread-safe: no shared mutable state (results flow through channels, not direct hash mutation)
- **Test**: level resolution for chains, diamonds, cycles, independent langs

### [x] Grammar install error handling
- `compile_sources` captures stderr from cc/gcc and returns `{Bool, String}` with compiler diagnostics
- `install_grammar_sync` captures stderr from git clone and tree-sitter generate (was discarded)
- `install_via_cc_async` captures stderr from git clone and surfaces compiler errors
- `retry_with_backoff` retries git clone on transient failures (3 attempts, 1s/2s/4s backoff)
- Error messages include stderr output from failed commands
- **Test**: broken C code returns stderr, missing parser.c returns specific error, failure details with structured context

---

## CLI Improvements

### [x] `tree-sitter-manager stats` subcommand
- Show: installed grammars, cached queries, supported languages count
- **Test**: `stats` command prints counts

### [x] `tree-sitter-manager groups` subcommand
- List semantic language groups and their members
- `groups scripting` shows python, ruby, javascript, etc.
- **Test**: lists groups correctly

### [x] `tree-sitter-manager doctor` subcommand
- Check grammar health, query validity, cache state
- **Test**: doctor reports issues with actionable messages

### [x] Auto-install grammars on highlight
- When grammar is missing, install automatically before highlighting
- TUI shows spinner animation during install (`Bubbles::Spinner::MiniDot`)
- File selection is queued when grammar is already installing
- Install errors are displayed in the viewport
- **Test**: InstallDoneMsg creation, install state management, queue behavior

---

## Language Data

### [x] Content-based extension tiebreaking
- Integrate `LanguageDetection.resolve` into `guess_language`
- For ambiguous extensions, use content for tiebreaking
- **Test**: ambiguous extension with vim modeline resolves correctly

### [ ] Language pack version check
- Compare installed grammar ABI version with language_definitions.json
- Warn on outdated grammars
- **Test**: outdated grammar shows warning

---

## Polish

### [x] `tree-sitter-manager --version`
- Print version from shard.yml
- **Test**: `--version` prints version

### [x] Shell completions
- `tree-sitter-manager completions bash|zsh|fish` outputs completion script to stdout
- User can source the output or pipe to completion file
- **Test**: scripts contain correct patterns for each shell, error on unknown shell

### [x] Config file support
- `~/.config/chiasmus/config.toml`
- Default theme, default output format, cache dir, auto-install
- CLI flags override config, config overrides hardcoded defaults
- **Test**: config file overrides defaults, partial config falls back, load with no file

---

## Deferred

### [ ] WASM support (item 4 from parity.md)
- Crystal WASM target compilation
- JavaScript FFI bindings

### [ ] WASM build tool (item 14 from parity.md)
- C header stubs for wasm32-unknown-unknown
