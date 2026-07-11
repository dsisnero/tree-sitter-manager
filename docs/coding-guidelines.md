# Coding Guidelines

## Style

- Follow `crystal tool format` (enforced by CI).
- Use snake_case for methods and variables, CamelCase for classes and structs.
- Prefer Crystal's standard library over custom implementations.

## Error Handling

- All subprocess stderr must be captured and surfaced with context.
- Use `BoolResult` / `StringResult` for operation results that may fail.
- Never raise exceptions for expected control flow; use Result types.

## Naming

- `getter?` for boolean query methods (not `property?`).
- Prefix private methods with `private`.
- Use `self.` prefix for class methods, not `def self.method`.

## Async

- Grammar operations use fibers + channels; never block the event loop.
- Channel payload `Bool` for signaling, never `Channel(Nil)`.
- `receive?` in select for close-safe receives.
- Worker Pool pattern for parallel work with bounded concurrency.

## Crystal Gotchas

- `Tea::KeyPressMsg` is an alias for `Tea::Key`, not `Tea::KeyMsg`.
- Crystal does not allow `if cond && var = expr` — split into two lines.
