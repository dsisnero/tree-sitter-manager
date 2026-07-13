#!/usr/bin/env crystal
require "json"

LANG_DEFS  = "vendor/tree-sitter-language-pack/crates/ts-pack-core/language_definitions.json"
SYNTASTICA = "languages.toml"
OUTPUT     = "src/tree_sitter_manager/language_registry_generated.cr"

def normalize(name : String) : String
  name.split('-').map { |p| p[0].upcase + p[1..] }.join
end

# Load language-pack
raw = File.read(LANG_DEFS)
lang_defs = Hash(String, Hash(String, JSON::Any)).from_json(raw)

# Load syntastica query info
require "../lib/toml/src/toml"
synt_langs = {} of String => Hash(String, Bool)
TOML.parse_file(SYNTASTICA)["languages"].as_a.each do |l|
  h = l.as_h
  name = h["name"].as_s
  q = h["queries"]?.try(&.as_h)
  synt_langs[name] = {
    "nvim"  => q.try { |q| q["nvim-like"]?.try { |v| v.raw == true } } || true,
    "inj"   => q.try { |q| q["injections"]?.try { |v| v.raw == true } } || false,
    "local" => q.try { |q| q["locals"]?.try { |v| v.raw == true } } || false,
  }
end

STDERR.puts "Language-pack: #{lang_defs.size}, Syntastica query info: #{synt_langs.size}"

# Collect language data as arrays for output generation
lang_names = [] of String
lang_exts = [] of Array(String)
lang_gits = [] of String
lang_revs = [] of String
lang_ffi = [] of String
lang_csym = [] of String?
lang_dir = [] of String?
lang_abi = [] of Int64?
lang_gen = [] of Bool
lang_nvim = [] of Bool
lang_inj = [] of Bool
lang_loc = [] of Bool

lang_defs.each do |name, defn|
  repo = defn["repo"].as_s
  rev = defn["rev"]?.try(&.as_s) || ""
  branch = defn["branch"]?.try(&.as_s)
  dir = defn["directory"]?.try(&.as_s)
  gen = defn["generate"]?.try { |v| v.raw == true } || false
  abi = defn["abi_version"]?.try(&.as_i64)
  csym = defn["c_symbol"]?.try(&.as_s)
  exts = defn["extensions"]?.try(&.as_a).try(&.map(&.as_s)) || [] of String

  sym = csym || name.gsub('-', '_')
  ffi = "tree_sitter_#{sym}"

  syn = synt_langs[name]? || {"nvim" => true, "inj" => false, "local" => false}

  lang_names << name
  lang_exts << exts
  lang_gits << repo
  lang_revs << rev
  lang_ffi << ffi
  lang_csym << csym
  lang_dir << dir
  lang_abi << abi
  lang_gen << gen
  lang_nvim << syn["nvim"]
  lang_inj << syn["inj"]
  lang_loc << syn["local"]
end

n = lang_names.size

# Generate
File.open(OUTPUT, "w") do |io|
  io << "# Auto-generated — DO NOT EDIT\n"
  io << "# Sources: tree-sitter-language-pack (#{n} langs) + syntastica queries\n"
  io << "# Generated: #{Time.utc}\n\n"

  # Lang enum
  io << "module TreeSitterManager\n"
  io << "  module LanguageRegistryGenerated\n\n"
  io << "    enum Lang\n"
  n.times { |i| io << "      #{normalize(lang_names[i])}\n" }
  io << "\n"
  io << "      def name : String\n"
  io << "        case self\n"
  n.times { |i|
    en = normalize(lang_names[i]).downcase
    io << "        in .#{en}? then #{lang_names[i].inspect}\n"
  }
  io << "        end\n"
  io << "      end\n\n"
  io << "      def to_s(io : IO) : Nil\n        io << name\n      end\n\n"
  io << "      def self.parse?(name : String) : Lang?\n"
  io << "        case name\n"
  n.times { |i|
    en = normalize(lang_names[i])
    io << "        when #{lang_names[i].inspect} then Lang::#{en}\n"
  }
  io << "        else nil\n        end\n"
  io << "      end\n"
  io << "    end\n\n"

  # LANGUAGE_NAMES
  io << "    LANGUAGE_NAMES = [\n"
  n.times { |i| io << "      #{lang_names[i].inspect},\n" }
  io << "    ]\n\n"

  # LANGUAGES metadata
  io << "    LANGUAGES = [\n"
  n.times do |i|
    io << "      {\n"
    io << "        name: #{lang_names[i].inspect},\n"
    exts = lang_exts[i]
    if exts.empty?
      io << "        extensions: [] of String,\n"
    else
      ios = exts.map(&.inspect).join(", ")
      io << "        extensions: [#{ios}],\n"
    end
    io << "        git_url: #{lang_gits[i].inspect},\n"
    io << "        git_rev: #{lang_revs[i].inspect},\n"
    io << "        ffi_func: #{lang_ffi[i].inspect},\n"
    io << "        c_symbol: #{lang_csym[i].inspect},\n"
    io << "        directory: #{lang_dir[i].inspect},\n"
    abi = lang_abi[i] ? "#{lang_abi[i]}_i64" : "nil"
    io << "        abi_version: #{abi},\n"
    io << "        generate: #{lang_gen[i]},\n"
    io << "        nvim_like: #{lang_nvim[i]},\n"
    io << "        has_injections: #{lang_inj[i]},\n"
    io << "        has_locals: #{lang_loc[i]},\n"
    io << "      },\n"
  end
  io << "    ] of NamedTuple(name: String, extensions: Array(String), git_url: String, git_rev: String, ffi_func: String, c_symbol: String?, directory: String?, abi_version: Int64?, generate: Bool, nvim_like: Bool, has_injections: Bool, has_locals: Bool)\n"
  io << "  end\n"
  io << "end\n"
end
STDERR.puts "Generated #{OUTPUT} (#{n} languages)"
