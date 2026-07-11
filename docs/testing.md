# Testing

## Running Tests

```bash
crystal spec              # Full suite
crystal spec spec/path    # Single spec file
crystal spec spec/path:12 # Single example at line 12
```

## Conventions

- Specs go in `spec/`, mirroring `src/` structure.
- Use `describe` / `it` blocks with descriptive names.
- Test public API only; private methods are tested through public interfaces.

## Patterns

- **Unit tests**: test a single class/module in isolation.
- **Integration tests**: test the full pipeline (highlight → render).
- **Golden tests**: compare rendered output against expected output byte-for-byte.
- **Async tests**: use channels and timeouts for fiber-based operations.

## Gates

```bash
crystal tool format --check src spec bin  # Format check
ameba src spec bin                         # Lint
crystal spec                               # Tests
shards build                               # Build check
```
