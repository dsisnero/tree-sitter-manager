# Tree-Sitter Language Pack Augmentation Plan

Upstream: [xberg-io/tree-sitter-language-pack](https://github.com/xberg-io/tree-sitter-language-pack) (vendor/tree-sitter-language-pack)

Code intelligence (intel/, process(), etc.) excluded — will be part of Chiasmus.

Status codes: `[ ]` pending, `[~]` in-progress, `[x]` done

---

## 1. [x] Language aliases

Port the alias table from `registry.rs:19-26`. Resolve common alternate names to
canonical language names before registry lookup.

```crystal
# LanguageRegistry: resolve_alias(name) → canonical name
ALIASES = {
  "shell"     => "bash",
  "bazel"     => "starlark",
  "gradle"    => "groovy",
  "ignorefile"=> "gitignore",
  "lisp"      => "commonlisp",
  "makefile"  => "make",
}
```

- **Test**: `get_language_info("shell")` returns bash info
- **Files**: `language_registry.cr` — add `resolve_alias`, update lookup methods

## 2. [x] C symbol override table

Port `c_symbol_for()` from `registry.rs:28-52`. Some languages export
`tree_sitter_c_sharp` but the language name is `csharp`. Bridge this gap.

```crystal
C_SYMBOL_OVERRIDES = {
  "csharp"     => "c_sharp",
  "c-sharp"    => "c_sharp",
  "typescript" => "typescript",
  "tsx"        => "tsx",
}
```

- **Test**: `GrammarLoader.find_grammar_library("csharp")` looks for `tree_sitter_c_sharp.so`
- **Files**: `grammar_loader.cr` — use override when building symbol name

## 3. [x] Semantic language groups

Augment `languages.toml` with `group` field for curated sets (web, systems,
scripting, data, config, markup, query). Replace the existing `some/most/all`
tiers that no parser collection uses.

```toml
[[languages]]
name = "python"
group = ["scripting", "web"]  # can belong to multiple groups
```

- **Test**: `LanguageRegistry.languages_in_group("web")` returns relevant languages
- **Files**: `languages.toml` + `language_registry.cr` + generator

## 4. [x] Content-based language detection

Port `detect_language_from_content()` from `extensions.rs`. Use shebangs
(`#!/usr/bin/env python`), vim modelines, and Emacs file variables to detect
language when extension is missing or ambiguous.

- **Test**: `detect_language_from_content("#!/bin/bash\necho hi")` returns `"bash"`
- **Files**: new `language_detection.cr` module

## 5. [x] Ambiguous extension support

Port `ambiguous` field from `definitions.rs:27-28`. Some extensions point to
multiple languages (`.m` → ObjC or MATLAB). When an ambiguous extension is
encountered, use content-based detection as a tiebreaker.

```toml
[[languages]]
name = "objc"
extensions = ["m"]
ambiguous = { m = ["matlab"] }
```

- **Test**: `.m` file with ObjC content resolves to `"objc"`, MATLAB content to `"matlab"`
- **Files**: `languages.toml` + `language_registry.cr` + `language_detection.cr`

## 6. [x] Pre-built binary download

Port the download system from `download.rs`. Fetch pre-compiled `.so`/`.dylib`
from GitHub releases as an alternative to building from source. Cache in
`~/.cache/tree-sitter-manager/libs/`. Validate with SHA256.

- **Test**: `GrammarManager.ensure_grammar("python")` downloads pre-built `.so` when available, falls back to build
- **Files**: new `grammar_download.cr` module + `GrammarManager` integration

## 7. [x] Enhanced language definition schema

Add fields from `definitions.rs` to `languages.toml` and the generated
`LanguageInfo` record:

| Field | Type | Description |
|-------|------|-------------|
| `abi_version` | `UInt32?` | Required tree-sitter ABI version |
| `branch` | `String?` | Git branch (alternative to `rev`) |
| `generate` | `Bool` | Whether to run `tree-sitter generate` before build |
| `directory` | `String?` | Subdirectory in repo containing grammar |
| `c_symbol` | `String?` | Override for `tree_sitter_<name>()` symbol |

- **Test**: generator produces correct `LanguageInfo` from TOML
- **Files**: `languages.toml` + `scripts/generate_language_registry.cr` + `language_registry.cr`

## 8. [x] Additional query types

Add `folds`, `indents`, and `tags` query types alongside existing `highlights`,
`injections`, `locals`. Port `QueryKind` enum and `QueryCache` from
`query_cache.rs`.

```crystal
enum QueryKind
  Highlights
  Folds
  Indents
  Injections
  Locals
  Tags
end
```

- **Test**: `QueryManager.load_queries("python")` returns all 6 query types when available
- **Files**: `query_manager.cr` + queries directory structure

---

## Priority Order

1. Language aliases + C symbol overrides (small, high impact)
2. Content-based detection (new capability)
3. Semantic language groups (organizational improvement)
4. Enhanced definition schema (foundation for later features)
5. Ambiguous extensions (edge case handling)
6. Additional query types (folds/indents/tags)
7. Pre-built binary download (infrastructure)
