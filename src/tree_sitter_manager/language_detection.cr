module TreeSitterManager
  # Language detection from file content — ported from tree-sitter-language-pack extensions.rs.
  #
  # Detects language by inspecting:
  #   1. Shebang line (`#!/usr/bin/env python`)
  #   2. Vim modelines (`vim: set filetype=python:`)
  #   3. Emacs file variables (`-*- mode: ruby -*-`)
  module LanguageDetection
    extend self

    # Known shebang patterns → language name
    SHEBANG_PATTERNS = {
      /python3?\b/ => "python",
      /ruby\b/     => "ruby",
      /bash\b/     => "bash",
      /\bsh\b/     => "bash",
      /node\b/     => "javascript",
      /perl\b/     => "perl",
      /php\b/      => "php",
      /lua\b/      => "lua",
      /raku\b/     => "raku",
      /make\b/     => "make",
      /groovy\b/   => "groovy",
      /scala\b/    => "scala",
      /ocaml\b/    => "ocaml",
      /deno\b/     => "javascript",
      /tsx?\b/     => "typescript",
    }

    # Detect language from file content using shebang, modelines, or Emacs file variables.
    # Returns the language name string or nil if unable to detect.
    def detect_from_content(content : String) : String?
      return nil if content.empty?

      # Try shebang (must be on first line)
      if content.starts_with?("#!")
        first_line = content.lines.first?
        if first_line
          SHEBANG_PATTERNS.each do |pattern, lang|
            return lang if first_line =~ pattern
          end
        end
      end

      # Try vim modeline: vim: set filetype=python:
      if content =~ /vim?:\s*(set\s+)?(filetype|ft)=(\w+)/
        return canonicalize($3)
      end

      # Try Emacs file variable: -*- mode: ruby -*-
      if content =~ /-\*-\s*mode:\s*(\S+)\s*-\*-/
        return canonicalize($1)
      end

      nil
    end

    # Map common filetype names to tree-sitter language names.
    FILETYPE_ALIASES = {
      "dockerfile" => ["docker", "dockerfile"],
      "markdown"   => ["markdown", "md"],
      "csharp"     => ["csharp", "c#"],
      "typescript" => ["typescript", "ts"],
      "javascript" => ["javascript", "js"],
      "python"     => ["python", "py"],
      "ruby"       => ["ruby", "rb"],
      "rust"       => ["rust", "rs"],
      "golang"     => ["go", "golang"],
      "cpp"        => ["cpp", "c++", "cxx"],
      "bash"       => ["sh", "shell", "bash"],
      "yaml"       => ["yaml", "yml"],
      "java"       => ["java"],
      "c"          => ["c"],
      "html"       => ["html"],
      "css"        => ["css"],
      "json"       => ["json"],
      "xml"        => ["xml"],
      "sql"        => ["sql"],
      "lua"        => ["lua"],
      "php"        => ["php"],
      "perl"       => ["perl"],
      "make"       => ["make"],
      "toml"       => ["toml"],
      "haskell"    => ["haskell"],
      "kotlin"     => ["kotlin"],
      "swift"      => ["swift"],
      "scala"      => ["scala"],
      "elixir"     => ["elixir"],
      "erlang"     => ["erlang"],
      "clojure"    => ["clojure"],
      "dart"       => ["dart"],
      "r"          => ["r"],
      "ocaml"      => ["ocaml"],
      "zig"        => ["zig"],
      "cmake"      => ["cmake"],
    }

    FILETYPE_TO_LANGUAGE = begin
      map = {} of String => String
      FILETYPE_ALIASES.each do |language, aliases|
        aliases.each { |alias_name| map[alias_name] = language }
      end
      map
    end

    private def canonicalize(filetype : String) : String
      filetype_lower = filetype.downcase
      FILETYPE_TO_LANGUAGE.fetch(filetype_lower, filetype_lower)
    end

    # Resolve language from file extension, using content as tiebreaker for ambiguous extensions.
    # Returns the language name or nil if unable to determine.
    def resolve(extension : String, content : String) : String?
      ext_key = extension.downcase
      primary = LanguageRegistry.language_for_extension(ext_key)
      candidates = LanguageRegistry.ambiguous_for(ext_key)

      if !candidates.empty?
        if detected = detect_from_content(content)
          return detected if candidates.includes?(detected)
        end
        primary
      else
        primary
      end
    end
  end
end
