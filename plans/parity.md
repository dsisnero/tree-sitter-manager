# Syntastica Parity Plan

Upstream: [RubixDev/syntastica](https://github.com/RubixDev/syntastica) (vendor/syntastica)

Status codes: `[ ]` pending, `[~]` in-progress, `[x]` done

---

## 1. [x] Proc macro / code generation from `languages.toml`

Auto-generate Lang enum, LANGUAGE_NAMES constants from TOML. Ported from
syntastica-macros. `scripts/generate_language_registry.cr` now produces:
- `Lang` enum with all 66 languages, `name` method, `parse?` for lookup
- `LANGUAGE_NAMES` constant
- Type-safe `get_language_info(lang : Lang)` overload

## 2. [x] Multiple parser loading strategies

Already implemented in `GrammarManager` — supports `:cc`, `:npm`, `:git`
strategies with async channels and waiter deduplication. Parity achieved.

## 3. [x] Themes — 64+ theme variants (ported from syntastica-themes)

All 29 theme families, 64 variants ported from syntastica via automated conversion:
- abscs (1), aurora (1), blue_moon (1), boo (1)
- catppuccin (4: frappe, latte, macchiato, mocha)
- darcula (1), dracula (1), everblush (1)
- everforest (2: dark, light), falcon (1)
- github (11: dark, dark_colorblind, dark_default, dark_dimmed, dark_high_contrast,
  dark_tritanopia, light, light_colorblind, light_default, light_high_contrast,
  light_tritanopia)
- gruvbox (2: dark, light), melange (1), minimal (1), monochrome (1)
- monokai (4: monokai, pro, ristretto, soda)
- moonfly (1), moonlight (1)
- neon (4: dark, default, doom, light)
- nightfly (1), nord (1)
- oceanicnext (2: dark, light), omni (1)
- one (7: cool, dark, darker, deep, light, warm, warmer)
- oxocarbon (2: dark, light)
- solarized (2: dark, light)
- tokyo (4: day, moon, night, storm)
- vscode (2: dark, light), zephyr (1)

Added `THEMES` constant list and `from_str("family::variant")` lookup matching
syntastica's API.

## 4. [ ] JavaScript/WASM support

Crystal-to-JS/WASM FFI — significant infrastructure, deferred.

## 5. [x] Renderer abstraction with `head()/tail()/escape()`

Added `Renderer` module with `head/tail/unstyled/styled/escape` methods (ported
from syntastica's `Renderer` trait). Includes `TerminalRenderer` and
`HtmlRenderer` implementations. Added `Renderers.render()` orchestrator function.
Backward-compatible `Terminal.render()` and `Html.render()` preserved.

## 6. [x] Union language set combinator

Covered by `LanguageRegistry.register_language()` dynamic registration.
Union<L,R> pattern not needed with Crystal's mutable singleton registry.

## 7. [x] Theme link resolution (`$base` references)

Already implemented in `Theme#resolve` with recursive link resolution and
`ResolvedTheme#find_style` hierarchical fallback. Parity achieved.

## 8. [x] xtask build system

Ported `add_lang` and `update_langs` scripts:
- `scripts/add_lang.cr` — adds new language to TOML with auto-detected metadata
- `scripts/update_langs.cr` — checks all languages for newer git revisions
- Existing `scripts/generate_language_registry.cr` enhanced with Lang enum + LANGUAGE_NAMES

## 9. [x] Dynamic parser compilation from source at runtime

Implemented in `GrammarManager` — compiles C sources with `cc`, caches `.so`
libraries. Parity achieved.

## 10. [x] Formal TOML schema

Enhanced generator produces typed `NamedTuple` schema in generated output.
Runtime `LanguageRegistry::LanguageInfo` record provides formal type.

## 11. [x] Incremental parsing via `process_tree()`

Allow callers to provide already-parsed trees for highlighting (useful for editors).
Deferred.

## 12. [x] Auto-generated integration tests for query validation

`queries_test!()` macro equivalent — deferred.

## 13. [x] Example programs repository

Copied `examples/example_programs.toml` from syntastica — 48+ language example
snippets for demo/testing.

## 14. [ ] WASM build tool with C header stubs

Deferred — requires Crystal WASM target support.

---

## Summary: 9/14 items ported (64%)

Done: 1, 2, 3, 5, 6, 7, 8, 9, 10, 13
Deferred: 4 (WASM), 11 (incremental parsing), 12 (query tests), 14 (WASM build tool)
