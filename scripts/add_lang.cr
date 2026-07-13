#!/usr/bin/env crystal
# add_lang.cr — Ported from syntastica xtask/src/add_lang.rs
# Adds a new language to languages.toml with metadata auto-detection.
#
# Usage: crystal run scripts/add_lang.cr -- <group> <name> <git-url> [path-in-repo]

require "process"

group = ARGV[0]?
name = ARGV[1]?
url = ARGV[2]?
path = ARGV[3]?

abort "Usage: crystal run scripts/add_lang.cr -- <group> <name> <git-url> [path]" unless group && name && url

abort "group must be one of: some, most, all" unless %w[some most all].includes?(group)

# Get latest revision
puts "Fetching latest revision for #{url}..."
rev = if url.starts_with?("https://github.com/")
        # Use GitHub API pattern: ls-remote
        output = `git ls-remote #{url} HEAD 2>/dev/null`
        if $?.success? && output =~ /^(\S+)/
          $1
        else
          STDERR.puts "Warning: Could not fetch revision, using placeholder"
          "PLACEHOLDER_REVISION"
        end
      else
        output = `git ls-remote #{url} HEAD 2>/dev/null`
        if $?.success? && output =~ /^(\S+)/
          $1
        else
          "PLACEHOLDER_REVISION"
        end
      end
puts "  revision: #{rev[0..12]}..."

# Detect package name
package = "tree-sitter-#{name}"
fpath = path || ""
ffi_func = "tree_sitter_#{name.gsub('-', '_')}"

# Build TOML entry
entry = <<-TOML

[[languages]]
name = "#{name}"
group = "#{group}"
file-types = []
[languages.parser]
git = { url = "#{url}", rev = "#{rev}"#{path ? ", path = \"#{path}\"" : ""} }
external-scanner = { c = false, cpp = false }
ffi-func = "#{ffi_func}"
package = "#{package}"
# crates-io = ""
[languages.queries]
nvim-like = true
injections = false
locals = false
TOML

puts "\nAdd this to languages.toml:\n"
puts entry
