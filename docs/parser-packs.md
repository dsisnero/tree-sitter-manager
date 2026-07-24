# Parser packs

`TreeSitterManager::ParserPack` installs a prebuilt, platform-specific set of
native grammar libraries into the normal grammar cache. This gives deployments a
cache-first, offline path: ship the bundle with the application and set
`TREE_SITTER_MANAGER_PARSER_PACK_DIR` to its directory before initializing
`GrammarManager`.

The bundle directory contains `parser-pack.json` and the grammar libraries it
declares:

```json
{
  "version": 1,
  "platform": "macos-aarch64",
  "parsers": [
    {
      "language": "python",
      "file": "python/libtree-sitter-python.dylib",
      "sha256": "<sha256 of the library>"
    }
  ]
}
```

The installer checks that the manifest matches `Platform.artifact_tag`, rejects
unsafe paths, validates every SHA-256 before changing the cache, copies files
atomically, and registers the cache with `GrammarLoader`.

This is the local-install half of the parser-pack workflow. A release client can
download an archive and verify its archive checksum, extract it to a temporary
directory, then invoke `ParserPack.install_from_directory` using the same
manifest contract.
