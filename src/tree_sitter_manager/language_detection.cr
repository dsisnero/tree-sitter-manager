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
    private def canonicalize(filetype : String) : String
      case filetype.downcase
      when "javascript", "js"     then "javascript"
      when "typescript", "ts"     then "typescript"
      when "python", "py"         then "python"
      when "ruby", "rb"           then "ruby"
      when "rust", "rs"           then "rust"
      when "go", "golang"         then "go"
      when "java"                 then "java"
      when "c"                    then "c"
      when "cpp", "c++", "cxx"    then "cpp"
      when "csharp", "c#"         then "csharp"
      when "sh", "shell", "bash"  then "bash"
      when "html"                 then "html"
      when "css"                  then "css"
      when "json"                 then "json"
      when "yaml", "yml"          then "yaml"
      when "xml"                  then "xml"
      when "markdown", "md"       then "markdown"
      when "sql"                  then "sql"
      when "lua"                  then "lua"
      when "php"                  then "php"
      when "perl"                 then "perl"
      when "docker", "dockerfile" then "dockerfile"
      when "make"                 then "make"
      when "toml"                 then "toml"
      when "haskell"              then "haskell"
      when "kotlin"               then "kotlin"
      when "swift"                then "swift"
      when "scala"                then "scala"
      when "elixir"               then "elixir"
      when "erlang"               then "erlang"
      when "clojure"              then "clojure"
      when "dart"                 then "dart"
      when "r"                    then "r"
      when "ocaml"                then "ocaml"
      when "zig"                  then "zig"
      when "cmake"                then "cmake"
      else
        filetype.downcase
      end
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
