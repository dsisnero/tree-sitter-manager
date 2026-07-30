# Auto-generated — DO NOT EDIT
# Sources: tree-sitter-language-pack (306 langs) + syntastica queries
# Generated: 2026-07-30 02:20:12 UTC

module TreeSitterManager
  module LanguageRegistryGenerated
    enum Lang
      Abl
      Actionscript
      Ada
      Agda
      Al
      Angular
      Apex
      Arduino
      Asciidoc
      Asm
      Astro
      Awk
      Bash
      Bass
      Batch
      Beancount
      Bibtex
      Bicep
      Bitbake
      Blade
      Brightscript
      Bsl
      C
      C3
      Caddy
      Cairo
      Capnp
      Cedar
      Cedarschema
      Cel
      Cfml
      Chatito
      Chuck
      Circom
      Clarity
      Clojure
      Cmake
      Cobol
      Comment
      Commonlisp
      Cooklang
      Corn
      Cpon
      Cpp
      Crystal
      Csharp
      Css
      Cst
      Csv
      Cuda
      Cue
      Cylc
      D
      Dart
      Desktop
      Devicetree
      Dhall
      Diff
      Djot
      Dockerfile
      Dot
      Doxygen
      Dtd
      Earthfile
      Ebnf
      Editorconfig
      Eds
      Eex
      Elisp
      Elixir
      Elm
      Elsa
      Elvish
      Embeddedtemplate
      Enforce
      Erlang
      Facility
      Faust
      Fennel
      Fidl
      Firrtl
      Fish
      Foam
      Forth
      Fortran
      Fsharp
      Fsharp_signature
      Func
      Gap
      Gdscript
      Gdshader
      Git_config
      Git_rebase
      Gitattributes
      Gitcommit
      Gitignore
      Gherkin
      Gleam
      Glimmer
      Glsl
      Gn
      Gnuplot
      Go
      Godot_resource
      Gomod
      Gosum
      Gotmpl
      Gowork
      Gpg
      Graphql
      Gren
      Groovy
      Gstlaunch
      Hack
      Hare
      Haskell
      Haxe
      Hcl
      Heex
      Hjson
      Hlsl
      Hocon
      Hoon
      Html
      Htmldjango
      Http
      Hurl
      Hyprlang
      Idris
      Ini
      Ispc
      Jai
      Janet
      Java
      Javadoc
      Javascript
      Jinja2
      Jq
      Jsdoc
      Json
      Json5
      Jsonnet
      Julia
      Just
      Kcl
      Kconfig
      Kdl
      Kotlin
      Latex
      Lean
      Ledger
      Less
      Linkerscript
      Liquid
      Llvm
      Lua
      Luadoc
      Luap
      Luau
      Magik
      Make
      Markdown
      Markdown_inline
      Matlab
      Mermaid
      Meson
      Mlir
      Mojo
      Move
      Nasm
      Netlinx
      Nginx
      Nickel
      Nim
      Ninja
      Nix
      Norg
      Norg_meta
      Nqc
      Nushell
      Objc
      Ocaml
      Ocaml_interface
      Ocamllex
      Odin
      Openscad
      Org
      Pascal
      Pem
      Perl
      Pgn
      Php
      Phpdoc
      Pkl
      Po
      Poe_filter
      Pony
      Postscript
      Powershell
      Printf
      Prisma
      Prolog
      Promql
      Properties
      Proto
      Prql
      Psv
      Pug
      Puppet
      Purescript
      Pymanifest
      Python
      Ql
      Qmldir
      Qmljs
      Query
      R
      Racket
      Rasi
      Razor
      Rbs
      Re2c
      Readline
      Regex
      Rego
      Requirements
      Rescript
      Robot
      Roc
      Ron
      Rst
      Rtf
      Ruby
      Rust
      Scala
      Scheme
      Scss
      Slang
      Smali
      Smalltalk
      Smithy
      Sml
      Snakemake
      Solidity
      Souffle
      Sourcepawn
      Sparql
      Sql
      Sql_bigquery
      Squirrel
      Ssh_config
      Stan
      Starlark
      Superhtml
      Svelte
      Sway
      Swift
      Systemverilog
      Tablegen
      Tact
      Tcl
      Teal
      Templ
      Tera
      Terraform
      Test
      Textproto
      Thrift
      Tlaplus
      Tmux
      Todotxt
      Toml
      Tsv
      Tsx
      Turtle
      Twig
      Typescript
      Typespec
      Typoscript
      Typst
      Udev
      Ungrammar
      Uxntal
      V
      Vb
      Verilog
      Vhdl
      Vhs
      Vim
      Vimdoc
      Vrl
      Vue
      Wast
      Wat
      Wgsl
      Wgsl_bevy
      Wit
      X86asm
      Xcompose
      Xml
      Yaml
      Yuck
      Zig
      Ziggy
      Ziggy_schema
      Zsh

      def name : String
        case self
        in .abl?              then "abl"
        in .actionscript?     then "actionscript"
        in .ada?              then "ada"
        in .agda?             then "agda"
        in .al?               then "al"
        in .angular?          then "angular"
        in .apex?             then "apex"
        in .arduino?          then "arduino"
        in .asciidoc?         then "asciidoc"
        in .asm?              then "asm"
        in .astro?            then "astro"
        in .awk?              then "awk"
        in .bash?             then "bash"
        in .bass?             then "bass"
        in .batch?            then "batch"
        in .beancount?        then "beancount"
        in .bibtex?           then "bibtex"
        in .bicep?            then "bicep"
        in .bitbake?          then "bitbake"
        in .blade?            then "blade"
        in .brightscript?     then "brightscript"
        in .bsl?              then "bsl"
        in .c?                then "c"
        in .c3?               then "c3"
        in .caddy?            then "caddy"
        in .cairo?            then "cairo"
        in .capnp?            then "capnp"
        in .cedar?            then "cedar"
        in .cedarschema?      then "cedarschema"
        in .cel?              then "cel"
        in .cfml?             then "cfml"
        in .chatito?          then "chatito"
        in .chuck?            then "chuck"
        in .circom?           then "circom"
        in .clarity?          then "clarity"
        in .clojure?          then "clojure"
        in .cmake?            then "cmake"
        in .cobol?            then "cobol"
        in .comment?          then "comment"
        in .commonlisp?       then "commonlisp"
        in .cooklang?         then "cooklang"
        in .corn?             then "corn"
        in .cpon?             then "cpon"
        in .cpp?              then "cpp"
        in .crystal?          then "crystal"
        in .csharp?           then "csharp"
        in .css?              then "css"
        in .cst?              then "cst"
        in .csv?              then "csv"
        in .cuda?             then "cuda"
        in .cue?              then "cue"
        in .cylc?             then "cylc"
        in .d?                then "d"
        in .dart?             then "dart"
        in .desktop?          then "desktop"
        in .devicetree?       then "devicetree"
        in .dhall?            then "dhall"
        in .diff?             then "diff"
        in .djot?             then "djot"
        in .dockerfile?       then "dockerfile"
        in .dot?              then "dot"
        in .doxygen?          then "doxygen"
        in .dtd?              then "dtd"
        in .earthfile?        then "earthfile"
        in .ebnf?             then "ebnf"
        in .editorconfig?     then "editorconfig"
        in .eds?              then "eds"
        in .eex?              then "eex"
        in .elisp?            then "elisp"
        in .elixir?           then "elixir"
        in .elm?              then "elm"
        in .elsa?             then "elsa"
        in .elvish?           then "elvish"
        in .embeddedtemplate? then "embeddedtemplate"
        in .enforce?          then "enforce"
        in .erlang?           then "erlang"
        in .facility?         then "facility"
        in .faust?            then "faust"
        in .fennel?           then "fennel"
        in .fidl?             then "fidl"
        in .firrtl?           then "firrtl"
        in .fish?             then "fish"
        in .foam?             then "foam"
        in .forth?            then "forth"
        in .fortran?          then "fortran"
        in .fsharp?           then "fsharp"
        in .fsharp_signature? then "fsharp_signature"
        in .func?             then "func"
        in .gap?              then "gap"
        in .gdscript?         then "gdscript"
        in .gdshader?         then "gdshader"
        in .git_config?       then "git_config"
        in .git_rebase?       then "git_rebase"
        in .gitattributes?    then "gitattributes"
        in .gitcommit?        then "gitcommit"
        in .gitignore?        then "gitignore"
        in .gherkin?          then "gherkin"
        in .gleam?            then "gleam"
        in .glimmer?          then "glimmer"
        in .glsl?             then "glsl"
        in .gn?               then "gn"
        in .gnuplot?          then "gnuplot"
        in .go?               then "go"
        in .godot_resource?   then "godot_resource"
        in .gomod?            then "gomod"
        in .gosum?            then "gosum"
        in .gotmpl?           then "gotmpl"
        in .gowork?           then "gowork"
        in .gpg?              then "gpg"
        in .graphql?          then "graphql"
        in .gren?             then "gren"
        in .groovy?           then "groovy"
        in .gstlaunch?        then "gstlaunch"
        in .hack?             then "hack"
        in .hare?             then "hare"
        in .haskell?          then "haskell"
        in .haxe?             then "haxe"
        in .hcl?              then "hcl"
        in .heex?             then "heex"
        in .hjson?            then "hjson"
        in .hlsl?             then "hlsl"
        in .hocon?            then "hocon"
        in .hoon?             then "hoon"
        in .html?             then "html"
        in .htmldjango?       then "htmldjango"
        in .http?             then "http"
        in .hurl?             then "hurl"
        in .hyprlang?         then "hyprlang"
        in .idris?            then "idris"
        in .ini?              then "ini"
        in .ispc?             then "ispc"
        in .jai?              then "jai"
        in .janet?            then "janet"
        in .java?             then "java"
        in .javadoc?          then "javadoc"
        in .javascript?       then "javascript"
        in .jinja2?           then "jinja2"
        in .jq?               then "jq"
        in .jsdoc?            then "jsdoc"
        in .json?             then "json"
        in .json5?            then "json5"
        in .jsonnet?          then "jsonnet"
        in .julia?            then "julia"
        in .just?             then "just"
        in .kcl?              then "kcl"
        in .kconfig?          then "kconfig"
        in .kdl?              then "kdl"
        in .kotlin?           then "kotlin"
        in .latex?            then "latex"
        in .lean?             then "lean"
        in .ledger?           then "ledger"
        in .less?             then "less"
        in .linkerscript?     then "linkerscript"
        in .liquid?           then "liquid"
        in .llvm?             then "llvm"
        in .lua?              then "lua"
        in .luadoc?           then "luadoc"
        in .luap?             then "luap"
        in .luau?             then "luau"
        in .magik?            then "magik"
        in .make?             then "make"
        in .markdown?         then "markdown"
        in .markdown_inline?  then "markdown_inline"
        in .matlab?           then "matlab"
        in .mermaid?          then "mermaid"
        in .meson?            then "meson"
        in .mlir?             then "mlir"
        in .mojo?             then "mojo"
        in .move?             then "move"
        in .nasm?             then "nasm"
        in .netlinx?          then "netlinx"
        in .nginx?            then "nginx"
        in .nickel?           then "nickel"
        in .nim?              then "nim"
        in .ninja?            then "ninja"
        in .nix?              then "nix"
        in .norg?             then "norg"
        in .norg_meta?        then "norg_meta"
        in .nqc?              then "nqc"
        in .nushell?          then "nushell"
        in .objc?             then "objc"
        in .ocaml?            then "ocaml"
        in .ocaml_interface?  then "ocaml_interface"
        in .ocamllex?         then "ocamllex"
        in .odin?             then "odin"
        in .openscad?         then "openscad"
        in .org?              then "org"
        in .pascal?           then "pascal"
        in .pem?              then "pem"
        in .perl?             then "perl"
        in .pgn?              then "pgn"
        in .php?              then "php"
        in .phpdoc?           then "phpdoc"
        in .pkl?              then "pkl"
        in .po?               then "po"
        in .poe_filter?       then "poe_filter"
        in .pony?             then "pony"
        in .postscript?       then "postscript"
        in .powershell?       then "powershell"
        in .printf?           then "printf"
        in .prisma?           then "prisma"
        in .prolog?           then "prolog"
        in .promql?           then "promql"
        in .properties?       then "properties"
        in .proto?            then "proto"
        in .prql?             then "prql"
        in .psv?              then "psv"
        in .pug?              then "pug"
        in .puppet?           then "puppet"
        in .purescript?       then "purescript"
        in .pymanifest?       then "pymanifest"
        in .python?           then "python"
        in .ql?               then "ql"
        in .qmldir?           then "qmldir"
        in .qmljs?            then "qmljs"
        in .query?            then "query"
        in .r?                then "r"
        in .racket?           then "racket"
        in .rasi?             then "rasi"
        in .razor?            then "razor"
        in .rbs?              then "rbs"
        in .re2c?             then "re2c"
        in .readline?         then "readline"
        in .regex?            then "regex"
        in .rego?             then "rego"
        in .requirements?     then "requirements"
        in .rescript?         then "rescript"
        in .robot?            then "robot"
        in .roc?              then "roc"
        in .ron?              then "ron"
        in .rst?              then "rst"
        in .rtf?              then "rtf"
        in .ruby?             then "ruby"
        in .rust?             then "rust"
        in .scala?            then "scala"
        in .scheme?           then "scheme"
        in .scss?             then "scss"
        in .slang?            then "slang"
        in .smali?            then "smali"
        in .smalltalk?        then "smalltalk"
        in .smithy?           then "smithy"
        in .sml?              then "sml"
        in .snakemake?        then "snakemake"
        in .solidity?         then "solidity"
        in .souffle?          then "souffle"
        in .sourcepawn?       then "sourcepawn"
        in .sparql?           then "sparql"
        in .sql?              then "sql"
        in .sql_bigquery?     then "sql_bigquery"
        in .squirrel?         then "squirrel"
        in .ssh_config?       then "ssh_config"
        in .stan?             then "stan"
        in .starlark?         then "starlark"
        in .superhtml?        then "superhtml"
        in .svelte?           then "svelte"
        in .sway?             then "sway"
        in .swift?            then "swift"
        in .systemverilog?    then "systemverilog"
        in .tablegen?         then "tablegen"
        in .tact?             then "tact"
        in .tcl?              then "tcl"
        in .teal?             then "teal"
        in .templ?            then "templ"
        in .tera?             then "tera"
        in .terraform?        then "terraform"
        in .test?             then "test"
        in .textproto?        then "textproto"
        in .thrift?           then "thrift"
        in .tlaplus?          then "tlaplus"
        in .tmux?             then "tmux"
        in .todotxt?          then "todotxt"
        in .toml?             then "toml"
        in .tsv?              then "tsv"
        in .tsx?              then "tsx"
        in .turtle?           then "turtle"
        in .twig?             then "twig"
        in .typescript?       then "typescript"
        in .typespec?         then "typespec"
        in .typoscript?       then "typoscript"
        in .typst?            then "typst"
        in .udev?             then "udev"
        in .ungrammar?        then "ungrammar"
        in .uxntal?           then "uxntal"
        in .v?                then "v"
        in .vb?               then "vb"
        in .verilog?          then "verilog"
        in .vhdl?             then "vhdl"
        in .vhs?              then "vhs"
        in .vim?              then "vim"
        in .vimdoc?           then "vimdoc"
        in .vrl?              then "vrl"
        in .vue?              then "vue"
        in .wast?             then "wast"
        in .wat?              then "wat"
        in .wgsl?             then "wgsl"
        in .wgsl_bevy?        then "wgsl_bevy"
        in .wit?              then "wit"
        in .x86asm?           then "x86asm"
        in .xcompose?         then "xcompose"
        in .xml?              then "xml"
        in .yaml?             then "yaml"
        in .yuck?             then "yuck"
        in .zig?              then "zig"
        in .ziggy?            then "ziggy"
        in .ziggy_schema?     then "ziggy_schema"
        in .zsh?              then "zsh"
        end
      end

      def to_s(io : IO) : Nil
        io << name
      end

      def self.parse?(name : String) : Lang?
        case name
        when "abl"              then Lang::Abl
        when "actionscript"     then Lang::Actionscript
        when "ada"              then Lang::Ada
        when "agda"             then Lang::Agda
        when "al"               then Lang::Al
        when "angular"          then Lang::Angular
        when "apex"             then Lang::Apex
        when "arduino"          then Lang::Arduino
        when "asciidoc"         then Lang::Asciidoc
        when "asm"              then Lang::Asm
        when "astro"            then Lang::Astro
        when "awk"              then Lang::Awk
        when "bash"             then Lang::Bash
        when "bass"             then Lang::Bass
        when "batch"            then Lang::Batch
        when "beancount"        then Lang::Beancount
        when "bibtex"           then Lang::Bibtex
        when "bicep"            then Lang::Bicep
        when "bitbake"          then Lang::Bitbake
        when "blade"            then Lang::Blade
        when "brightscript"     then Lang::Brightscript
        when "bsl"              then Lang::Bsl
        when "c"                then Lang::C
        when "c3"               then Lang::C3
        when "caddy"            then Lang::Caddy
        when "cairo"            then Lang::Cairo
        when "capnp"            then Lang::Capnp
        when "cedar"            then Lang::Cedar
        when "cedarschema"      then Lang::Cedarschema
        when "cel"              then Lang::Cel
        when "cfml"             then Lang::Cfml
        when "chatito"          then Lang::Chatito
        when "chuck"            then Lang::Chuck
        when "circom"           then Lang::Circom
        when "clarity"          then Lang::Clarity
        when "clojure"          then Lang::Clojure
        when "cmake"            then Lang::Cmake
        when "cobol"            then Lang::Cobol
        when "comment"          then Lang::Comment
        when "commonlisp"       then Lang::Commonlisp
        when "cooklang"         then Lang::Cooklang
        when "corn"             then Lang::Corn
        when "cpon"             then Lang::Cpon
        when "cpp"              then Lang::Cpp
        when "crystal"          then Lang::Crystal
        when "csharp"           then Lang::Csharp
        when "css"              then Lang::Css
        when "cst"              then Lang::Cst
        when "csv"              then Lang::Csv
        when "cuda"             then Lang::Cuda
        when "cue"              then Lang::Cue
        when "cylc"             then Lang::Cylc
        when "d"                then Lang::D
        when "dart"             then Lang::Dart
        when "desktop"          then Lang::Desktop
        when "devicetree"       then Lang::Devicetree
        when "dhall"            then Lang::Dhall
        when "diff"             then Lang::Diff
        when "djot"             then Lang::Djot
        when "dockerfile"       then Lang::Dockerfile
        when "dot"              then Lang::Dot
        when "doxygen"          then Lang::Doxygen
        when "dtd"              then Lang::Dtd
        when "earthfile"        then Lang::Earthfile
        when "ebnf"             then Lang::Ebnf
        when "editorconfig"     then Lang::Editorconfig
        when "eds"              then Lang::Eds
        when "eex"              then Lang::Eex
        when "elisp"            then Lang::Elisp
        when "elixir"           then Lang::Elixir
        when "elm"              then Lang::Elm
        when "elsa"             then Lang::Elsa
        when "elvish"           then Lang::Elvish
        when "embeddedtemplate" then Lang::Embeddedtemplate
        when "enforce"          then Lang::Enforce
        when "erlang"           then Lang::Erlang
        when "facility"         then Lang::Facility
        when "faust"            then Lang::Faust
        when "fennel"           then Lang::Fennel
        when "fidl"             then Lang::Fidl
        when "firrtl"           then Lang::Firrtl
        when "fish"             then Lang::Fish
        when "foam"             then Lang::Foam
        when "forth"            then Lang::Forth
        when "fortran"          then Lang::Fortran
        when "fsharp"           then Lang::Fsharp
        when "fsharp_signature" then Lang::Fsharp_signature
        when "func"             then Lang::Func
        when "gap"              then Lang::Gap
        when "gdscript"         then Lang::Gdscript
        when "gdshader"         then Lang::Gdshader
        when "git_config"       then Lang::Git_config
        when "git_rebase"       then Lang::Git_rebase
        when "gitattributes"    then Lang::Gitattributes
        when "gitcommit"        then Lang::Gitcommit
        when "gitignore"        then Lang::Gitignore
        when "gherkin"          then Lang::Gherkin
        when "gleam"            then Lang::Gleam
        when "glimmer"          then Lang::Glimmer
        when "glsl"             then Lang::Glsl
        when "gn"               then Lang::Gn
        when "gnuplot"          then Lang::Gnuplot
        when "go"               then Lang::Go
        when "godot_resource"   then Lang::Godot_resource
        when "gomod"            then Lang::Gomod
        when "gosum"            then Lang::Gosum
        when "gotmpl"           then Lang::Gotmpl
        when "gowork"           then Lang::Gowork
        when "gpg"              then Lang::Gpg
        when "graphql"          then Lang::Graphql
        when "gren"             then Lang::Gren
        when "groovy"           then Lang::Groovy
        when "gstlaunch"        then Lang::Gstlaunch
        when "hack"             then Lang::Hack
        when "hare"             then Lang::Hare
        when "haskell"          then Lang::Haskell
        when "haxe"             then Lang::Haxe
        when "hcl"              then Lang::Hcl
        when "heex"             then Lang::Heex
        when "hjson"            then Lang::Hjson
        when "hlsl"             then Lang::Hlsl
        when "hocon"            then Lang::Hocon
        when "hoon"             then Lang::Hoon
        when "html"             then Lang::Html
        when "htmldjango"       then Lang::Htmldjango
        when "http"             then Lang::Http
        when "hurl"             then Lang::Hurl
        when "hyprlang"         then Lang::Hyprlang
        when "idris"            then Lang::Idris
        when "ini"              then Lang::Ini
        when "ispc"             then Lang::Ispc
        when "jai"              then Lang::Jai
        when "janet"            then Lang::Janet
        when "java"             then Lang::Java
        when "javadoc"          then Lang::Javadoc
        when "javascript"       then Lang::Javascript
        when "jinja2"           then Lang::Jinja2
        when "jq"               then Lang::Jq
        when "jsdoc"            then Lang::Jsdoc
        when "json"             then Lang::Json
        when "json5"            then Lang::Json5
        when "jsonnet"          then Lang::Jsonnet
        when "julia"            then Lang::Julia
        when "just"             then Lang::Just
        when "kcl"              then Lang::Kcl
        when "kconfig"          then Lang::Kconfig
        when "kdl"              then Lang::Kdl
        when "kotlin"           then Lang::Kotlin
        when "latex"            then Lang::Latex
        when "lean"             then Lang::Lean
        when "ledger"           then Lang::Ledger
        when "less"             then Lang::Less
        when "linkerscript"     then Lang::Linkerscript
        when "liquid"           then Lang::Liquid
        when "llvm"             then Lang::Llvm
        when "lua"              then Lang::Lua
        when "luadoc"           then Lang::Luadoc
        when "luap"             then Lang::Luap
        when "luau"             then Lang::Luau
        when "magik"            then Lang::Magik
        when "make"             then Lang::Make
        when "markdown"         then Lang::Markdown
        when "markdown_inline"  then Lang::Markdown_inline
        when "matlab"           then Lang::Matlab
        when "mermaid"          then Lang::Mermaid
        when "meson"            then Lang::Meson
        when "mlir"             then Lang::Mlir
        when "mojo"             then Lang::Mojo
        when "move"             then Lang::Move
        when "nasm"             then Lang::Nasm
        when "netlinx"          then Lang::Netlinx
        when "nginx"            then Lang::Nginx
        when "nickel"           then Lang::Nickel
        when "nim"              then Lang::Nim
        when "ninja"            then Lang::Ninja
        when "nix"              then Lang::Nix
        when "norg"             then Lang::Norg
        when "norg_meta"        then Lang::Norg_meta
        when "nqc"              then Lang::Nqc
        when "nushell"          then Lang::Nushell
        when "objc"             then Lang::Objc
        when "ocaml"            then Lang::Ocaml
        when "ocaml_interface"  then Lang::Ocaml_interface
        when "ocamllex"         then Lang::Ocamllex
        when "odin"             then Lang::Odin
        when "openscad"         then Lang::Openscad
        when "org"              then Lang::Org
        when "pascal"           then Lang::Pascal
        when "pem"              then Lang::Pem
        when "perl"             then Lang::Perl
        when "pgn"              then Lang::Pgn
        when "php"              then Lang::Php
        when "phpdoc"           then Lang::Phpdoc
        when "pkl"              then Lang::Pkl
        when "po"               then Lang::Po
        when "poe_filter"       then Lang::Poe_filter
        when "pony"             then Lang::Pony
        when "postscript"       then Lang::Postscript
        when "powershell"       then Lang::Powershell
        when "printf"           then Lang::Printf
        when "prisma"           then Lang::Prisma
        when "prolog"           then Lang::Prolog
        when "promql"           then Lang::Promql
        when "properties"       then Lang::Properties
        when "proto"            then Lang::Proto
        when "prql"             then Lang::Prql
        when "psv"              then Lang::Psv
        when "pug"              then Lang::Pug
        when "puppet"           then Lang::Puppet
        when "purescript"       then Lang::Purescript
        when "pymanifest"       then Lang::Pymanifest
        when "python"           then Lang::Python
        when "ql"               then Lang::Ql
        when "qmldir"           then Lang::Qmldir
        when "qmljs"            then Lang::Qmljs
        when "query"            then Lang::Query
        when "r"                then Lang::R
        when "racket"           then Lang::Racket
        when "rasi"             then Lang::Rasi
        when "razor"            then Lang::Razor
        when "rbs"              then Lang::Rbs
        when "re2c"             then Lang::Re2c
        when "readline"         then Lang::Readline
        when "regex"            then Lang::Regex
        when "rego"             then Lang::Rego
        when "requirements"     then Lang::Requirements
        when "rescript"         then Lang::Rescript
        when "robot"            then Lang::Robot
        when "roc"              then Lang::Roc
        when "ron"              then Lang::Ron
        when "rst"              then Lang::Rst
        when "rtf"              then Lang::Rtf
        when "ruby"             then Lang::Ruby
        when "rust"             then Lang::Rust
        when "scala"            then Lang::Scala
        when "scheme"           then Lang::Scheme
        when "scss"             then Lang::Scss
        when "slang"            then Lang::Slang
        when "smali"            then Lang::Smali
        when "smalltalk"        then Lang::Smalltalk
        when "smithy"           then Lang::Smithy
        when "sml"              then Lang::Sml
        when "snakemake"        then Lang::Snakemake
        when "solidity"         then Lang::Solidity
        when "souffle"          then Lang::Souffle
        when "sourcepawn"       then Lang::Sourcepawn
        when "sparql"           then Lang::Sparql
        when "sql"              then Lang::Sql
        when "sql_bigquery"     then Lang::Sql_bigquery
        when "squirrel"         then Lang::Squirrel
        when "ssh_config"       then Lang::Ssh_config
        when "stan"             then Lang::Stan
        when "starlark"         then Lang::Starlark
        when "superhtml"        then Lang::Superhtml
        when "svelte"           then Lang::Svelte
        when "sway"             then Lang::Sway
        when "swift"            then Lang::Swift
        when "systemverilog"    then Lang::Systemverilog
        when "tablegen"         then Lang::Tablegen
        when "tact"             then Lang::Tact
        when "tcl"              then Lang::Tcl
        when "teal"             then Lang::Teal
        when "templ"            then Lang::Templ
        when "tera"             then Lang::Tera
        when "terraform"        then Lang::Terraform
        when "test"             then Lang::Test
        when "textproto"        then Lang::Textproto
        when "thrift"           then Lang::Thrift
        when "tlaplus"          then Lang::Tlaplus
        when "tmux"             then Lang::Tmux
        when "todotxt"          then Lang::Todotxt
        when "toml"             then Lang::Toml
        when "tsv"              then Lang::Tsv
        when "tsx"              then Lang::Tsx
        when "turtle"           then Lang::Turtle
        when "twig"             then Lang::Twig
        when "typescript"       then Lang::Typescript
        when "typespec"         then Lang::Typespec
        when "typoscript"       then Lang::Typoscript
        when "typst"            then Lang::Typst
        when "udev"             then Lang::Udev
        when "ungrammar"        then Lang::Ungrammar
        when "uxntal"           then Lang::Uxntal
        when "v"                then Lang::V
        when "vb"               then Lang::Vb
        when "verilog"          then Lang::Verilog
        when "vhdl"             then Lang::Vhdl
        when "vhs"              then Lang::Vhs
        when "vim"              then Lang::Vim
        when "vimdoc"           then Lang::Vimdoc
        when "vrl"              then Lang::Vrl
        when "vue"              then Lang::Vue
        when "wast"             then Lang::Wast
        when "wat"              then Lang::Wat
        when "wgsl"             then Lang::Wgsl
        when "wgsl_bevy"        then Lang::Wgsl_bevy
        when "wit"              then Lang::Wit
        when "x86asm"           then Lang::X86asm
        when "xcompose"         then Lang::Xcompose
        when "xml"              then Lang::Xml
        when "yaml"             then Lang::Yaml
        when "yuck"             then Lang::Yuck
        when "zig"              then Lang::Zig
        when "ziggy"            then Lang::Ziggy
        when "ziggy_schema"     then Lang::Ziggy_schema
        when "zsh"              then Lang::Zsh
        else                         nil
        end
      end
    end

    LANGUAGE_NAMES = [
      "abl",
      "actionscript",
      "ada",
      "agda",
      "al",
      "angular",
      "apex",
      "arduino",
      "asciidoc",
      "asm",
      "astro",
      "awk",
      "bash",
      "bass",
      "batch",
      "beancount",
      "bibtex",
      "bicep",
      "bitbake",
      "blade",
      "brightscript",
      "bsl",
      "c",
      "c3",
      "caddy",
      "cairo",
      "capnp",
      "cedar",
      "cedarschema",
      "cel",
      "cfml",
      "chatito",
      "chuck",
      "circom",
      "clarity",
      "clojure",
      "cmake",
      "cobol",
      "comment",
      "commonlisp",
      "cooklang",
      "corn",
      "cpon",
      "cpp",
      "crystal",
      "csharp",
      "css",
      "cst",
      "csv",
      "cuda",
      "cue",
      "cylc",
      "d",
      "dart",
      "desktop",
      "devicetree",
      "dhall",
      "diff",
      "djot",
      "dockerfile",
      "dot",
      "doxygen",
      "dtd",
      "earthfile",
      "ebnf",
      "editorconfig",
      "eds",
      "eex",
      "elisp",
      "elixir",
      "elm",
      "elsa",
      "elvish",
      "embeddedtemplate",
      "enforce",
      "erlang",
      "facility",
      "faust",
      "fennel",
      "fidl",
      "firrtl",
      "fish",
      "foam",
      "forth",
      "fortran",
      "fsharp",
      "fsharp_signature",
      "func",
      "gap",
      "gdscript",
      "gdshader",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "gherkin",
      "gleam",
      "glimmer",
      "glsl",
      "gn",
      "gnuplot",
      "go",
      "godot_resource",
      "gomod",
      "gosum",
      "gotmpl",
      "gowork",
      "gpg",
      "graphql",
      "gren",
      "groovy",
      "gstlaunch",
      "hack",
      "hare",
      "haskell",
      "haxe",
      "hcl",
      "heex",
      "hjson",
      "hlsl",
      "hocon",
      "hoon",
      "html",
      "htmldjango",
      "http",
      "hurl",
      "hyprlang",
      "idris",
      "ini",
      "ispc",
      "jai",
      "janet",
      "java",
      "javadoc",
      "javascript",
      "jinja2",
      "jq",
      "jsdoc",
      "json",
      "json5",
      "jsonnet",
      "julia",
      "just",
      "kcl",
      "kconfig",
      "kdl",
      "kotlin",
      "latex",
      "lean",
      "ledger",
      "less",
      "linkerscript",
      "liquid",
      "llvm",
      "lua",
      "luadoc",
      "luap",
      "luau",
      "magik",
      "make",
      "markdown",
      "markdown_inline",
      "matlab",
      "mermaid",
      "meson",
      "mlir",
      "mojo",
      "move",
      "nasm",
      "netlinx",
      "nginx",
      "nickel",
      "nim",
      "ninja",
      "nix",
      "norg",
      "norg_meta",
      "nqc",
      "nushell",
      "objc",
      "ocaml",
      "ocaml_interface",
      "ocamllex",
      "odin",
      "openscad",
      "org",
      "pascal",
      "pem",
      "perl",
      "pgn",
      "php",
      "phpdoc",
      "pkl",
      "po",
      "poe_filter",
      "pony",
      "postscript",
      "powershell",
      "printf",
      "prisma",
      "prolog",
      "promql",
      "properties",
      "proto",
      "prql",
      "psv",
      "pug",
      "puppet",
      "purescript",
      "pymanifest",
      "python",
      "ql",
      "qmldir",
      "qmljs",
      "query",
      "r",
      "racket",
      "rasi",
      "razor",
      "rbs",
      "re2c",
      "readline",
      "regex",
      "rego",
      "requirements",
      "rescript",
      "robot",
      "roc",
      "ron",
      "rst",
      "rtf",
      "ruby",
      "rust",
      "scala",
      "scheme",
      "scss",
      "slang",
      "smali",
      "smalltalk",
      "smithy",
      "sml",
      "snakemake",
      "solidity",
      "souffle",
      "sourcepawn",
      "sparql",
      "sql",
      "sql_bigquery",
      "squirrel",
      "ssh_config",
      "stan",
      "starlark",
      "superhtml",
      "svelte",
      "sway",
      "swift",
      "systemverilog",
      "tablegen",
      "tact",
      "tcl",
      "teal",
      "templ",
      "tera",
      "terraform",
      "test",
      "textproto",
      "thrift",
      "tlaplus",
      "tmux",
      "todotxt",
      "toml",
      "tsv",
      "tsx",
      "turtle",
      "twig",
      "typescript",
      "typespec",
      "typoscript",
      "typst",
      "udev",
      "ungrammar",
      "uxntal",
      "v",
      "vb",
      "verilog",
      "vhdl",
      "vhs",
      "vim",
      "vimdoc",
      "vrl",
      "vue",
      "wast",
      "wat",
      "wgsl",
      "wgsl_bevy",
      "wit",
      "x86asm",
      "xcompose",
      "xml",
      "yaml",
      "yuck",
      "zig",
      "ziggy",
      "ziggy_schema",
      "zsh",
    ]

    LANGUAGES = [
      {
        name:           "abl",
        extensions:     ["p", "cls", "w"],
        git_url:        "https://github.com/usagi-coffee/tree-sitter-abl",
        git_rev:        "2e0cfa2f085a5a9b25f5f9b55afd9e23df151b97",
        git_branch:     nil,
        ffi_func:       "tree_sitter_abl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "actionscript",
        extensions:     ["as"],
        git_url:        "https://github.com/Rileran/tree-sitter-actionscript",
        git_rev:        "24919034fc78fdf9bedaac6616b6a60af20ab9b5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_actionscript",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "ada",
        extensions:     ["ada", "adb", "ads"],
        git_url:        "https://github.com/briot/tree-sitter-ada",
        git_rev:        "6b58259a08b1a22ba0247a7ce30be384db618da6",
        git_branch:     "master",
        ffi_func:       "tree_sitter_ada",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "agda",
        extensions:     ["agda"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-agda",
        git_rev:        "e8d47a6987effe34d5595baf321d82d3519a8527",
        git_branch:     "master",
        ffi_func:       "tree_sitter_agda",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "al",
        extensions:     ["al"],
        git_url:        "https://github.com/SShadowS/tree-sitter-al",
        git_rev:        "f150581de8dd4393b8774ead02098a20ecc1e527",
        git_branch:     nil,
        ffi_func:       "tree_sitter_al",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "angular",
        extensions:     [] of String,
        git_url:        "https://github.com/dlvandenberg/tree-sitter-angular",
        git_rev:        "38a8014ed5452cd6b7cf1399c00177a1f5374256",
        git_branch:     nil,
        ffi_func:       "tree_sitter_angular",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "apex",
        extensions:     ["trigger"],
        git_url:        "https://github.com/aheber/tree-sitter-sfapex",
        git_rev:        "27a3091a1a444ce19d6099e00cd3788f019d0c2b",
        git_branch:     "main",
        ffi_func:       "tree_sitter_apex",
        c_symbol:       nil,
        directory:      "apex",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "arduino",
        extensions:     ["ino"],
        git_url:        "https://github.com/ObserverOfTime/tree-sitter-arduino",
        git_rev:        "11dd46c9ae25135c473c0003a133bb06a484af0c",
        git_branch:     "master",
        ffi_func:       "tree_sitter_arduino",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "asciidoc",
        extensions:     ["adoc", "asciidoc"],
        git_url:        "https://github.com/cathaysia/tree-sitter-asciidoc",
        git_rev:        "e85c025994c8548682418d8330d9f7a4f2b6b556",
        git_branch:     nil,
        ffi_func:       "tree_sitter_asciidoc",
        c_symbol:       nil,
        directory:      "tree-sitter-asciidoc",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "asm",
        extensions:     ["s", "asm"],
        git_url:        "https://github.com/rush-rs/tree-sitter-asm",
        git_rev:        "839741fef4dab5128952334624905c82b40c7133",
        git_branch:     nil,
        ffi_func:       "tree_sitter_asm",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "astro",
        extensions:     ["astro"],
        git_url:        "https://github.com/virchau13/tree-sitter-astro",
        git_rev:        "213f6e6973d9b456c6e50e86f19f66877e7ef0ee",
        git_branch:     "master",
        ffi_func:       "tree_sitter_astro",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "awk",
        extensions:     ["awk"],
        git_url:        "https://github.com/Beaglefoot/tree-sitter-awk",
        git_rev:        "34bbdc7cce8e803096f47b625979e34c1be38127",
        git_branch:     nil,
        ffi_func:       "tree_sitter_awk",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "bash",
        extensions:     ["sh", "bash"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-bash",
        git_rev:        "a06c2e4415e9bc0346c6b86d401879ffb44058f7",
        git_branch:     "master",
        ffi_func:       "tree_sitter_bash",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "bass",
        extensions:     [] of String,
        git_url:        "https://github.com/vito/tree-sitter-bass",
        git_rev:        "28dc7059722be090d04cd751aed915b2fee2f89a",
        git_branch:     nil,
        ffi_func:       "tree_sitter_bass",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "batch",
        extensions:     ["bat", "cmd"],
        git_url:        "https://github.com/davidevofficial/tree-sitter-batch",
        git_rev:        "737a031b42240bf61bf7ea5e4356d4e0580dd6d9",
        git_branch:     nil,
        ffi_func:       "tree_sitter_batch",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "beancount",
        extensions:     ["beancount"],
        git_url:        "https://github.com/polarmutex/tree-sitter-beancount",
        git_rev:        "c5e6cdf260629f76035a0c0de830947f385ae622",
        git_branch:     "master",
        ffi_func:       "tree_sitter_beancount",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "bibtex",
        extensions:     ["bib"],
        git_url:        "https://github.com/latex-lsp/tree-sitter-bibtex",
        git_rev:        "8d04ed27b3bc7929f14b7df9236797dab9f3fa66",
        git_branch:     "master",
        ffi_func:       "tree_sitter_bibtex",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "bicep",
        extensions:     ["bicep"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-bicep",
        git_rev:        "bff59884307c0ab009bd5e81afd9324b46a6c0f9",
        git_branch:     nil,
        ffi_func:       "tree_sitter_bicep",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "bitbake",
        extensions:     ["bb", "bbappend", "bbclass"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-bitbake",
        git_rev:        "a5d04fdb5a69a02b8fa8eb5525a60dfb5309b73b",
        git_branch:     nil,
        ffi_func:       "tree_sitter_bitbake",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "blade",
        extensions:     ["blade"],
        git_url:        "https://github.com/EmranMR/tree-sitter-blade",
        git_rev:        "5dbdcb0ccbe91e64b038b41545d3acc26c74907a",
        git_branch:     nil,
        ffi_func:       "tree_sitter_blade",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "brightscript",
        extensions:     ["brs"],
        git_url:        "https://github.com/ajdelcimmuto/tree-sitter-brightscript",
        git_rev:        "253fdfaa23814cb46c2d5fc19049fa0f2f62c6da",
        git_branch:     nil,
        ffi_func:       "tree_sitter_brightscript",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "bsl",
        extensions:     ["bsl"],
        git_url:        "https://github.com/alkoleft/tree-sitter-bsl",
        git_rev:        "5752667f4d40879a533c4ffe3005da10ff0b5e29",
        git_branch:     "develop",
        ffi_func:       "tree_sitter_bsl",
        c_symbol:       nil,
        directory:      "grammars/bsl",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "c",
        extensions:     ["c", "h"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-c",
        git_rev:        "b780e47fc780ddc8da13afa35a3f4ed5c157823d",
        git_branch:     "master",
        ffi_func:       "tree_sitter_c",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "c3",
        extensions:     ["c3", "c3i", "c3t"],
        git_url:        "https://github.com/c3lang/tree-sitter-c3",
        git_rev:        "1c6a95234c62130763ed1c479f958b74fdbfdb2a",
        git_branch:     nil,
        ffi_func:       "tree_sitter_c3",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "caddy",
        extensions:     ["caddyfile"],
        git_url:        "https://github.com/Samonitari/tree-sitter-caddy",
        git_rev:        "65b60437983933d00809c8927e7d8a29ca26dfa3",
        git_branch:     nil,
        ffi_func:       "tree_sitter_caddy",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "cairo",
        extensions:     ["cairo"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-cairo",
        git_rev:        "6238f609bea233040fe927858156dee5515a0745",
        git_branch:     nil,
        ffi_func:       "tree_sitter_cairo",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "capnp",
        extensions:     ["capnp"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-capnp",
        git_rev:        "7b0883c03e5edd34ef7bcf703194204299d7099f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_capnp",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "cedar",
        extensions:     ["cedar"],
        git_url:        "https://github.com/DuskSystems/tree-sitter-cedar",
        git_rev:        "ac1fe619df3d4af9f797903d4b8852f12082a0d5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_cedar",
        c_symbol:       nil,
        directory:      "cedar",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "cedarschema",
        extensions:     ["cedarschema"],
        git_url:        "https://github.com/DuskSystems/tree-sitter-cedar",
        git_rev:        "ac1fe619df3d4af9f797903d4b8852f12082a0d5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_cedarschema",
        c_symbol:       nil,
        directory:      "cedarschema",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "cel",
        extensions:     ["cel"],
        git_url:        "https://github.com/bufbuild/tree-sitter-cel",
        git_rev:        "fd2e8efaa07e71e46dcc1d5c4c85556a742d8c36",
        git_branch:     nil,
        ffi_func:       "tree_sitter_cel",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "cfml",
        extensions:     ["cfc"],
        git_url:        "https://github.com/cfmleditor/tree-sitter-cfml",
        git_rev:        "a224ff10755bcd2d322dd6be2c09ec11280135fe",
        git_branch:     nil,
        ffi_func:       "tree_sitter_cfml",
        c_symbol:       nil,
        directory:      "cfml",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "chatito",
        extensions:     ["chatito"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-chatito",
        git_rev:        "c0ed82c665b732395073f635c74c300f09530a7f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_chatito",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "chuck",
        extensions:     ["ck"],
        git_url:        "https://github.com/tymbalodeon/tree-sitter-chuck",
        git_rev:        "68fb7bdba480915d87177feaa5593a666c0bb602",
        git_branch:     nil,
        ffi_func:       "tree_sitter_chuck",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "circom",
        extensions:     ["circom"],
        git_url:        "https://github.com/Decurity/tree-sitter-circom",
        git_rev:        "02150524228b1e6afef96949f2d6b7cc0aaf999e",
        git_branch:     nil,
        ffi_func:       "tree_sitter_circom",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "clarity",
        extensions:     ["clar"],
        git_url:        "https://github.com/xlittlerag/tree-sitter-clarity",
        git_rev:        "1436da3946359fcd7ac2d81917aaa78ef1e01755",
        git_branch:     nil,
        ffi_func:       "tree_sitter_clarity",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "clojure",
        extensions:     ["clj", "cljs", "cljc"],
        git_url:        "https://github.com/sogaiu/tree-sitter-clojure",
        git_rev:        "e43eff80d17cf34852dcd92ca5e6986d23a7040f",
        git_branch:     "master",
        ffi_func:       "tree_sitter_clojure",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "cmake",
        extensions:     ["cmake"],
        git_url:        "https://github.com/uyha/tree-sitter-cmake",
        git_rev:        "93fa0f15929d06f96eba6daeda7ea878b1010c71",
        git_branch:     "master",
        ffi_func:       "tree_sitter_cmake",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "cobol",
        extensions:     ["cobol", "cob", "cbl"],
        git_url:        "https://github.com/nolanlwin/tree-sitter-cobol",
        git_rev:        "6f1a60ad52b52ccb5e794985454c6743531f17d7",
        git_branch:     nil,
        ffi_func:       "tree_sitter_cobol",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "comment",
        extensions:     [] of String,
        git_url:        "https://github.com/stsewd/tree-sitter-comment",
        git_rev:        "66272d2b6c73fb61157541b69dd0a7ce7b42a5ad",
        git_branch:     "master",
        ffi_func:       "tree_sitter_comment",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "commonlisp",
        extensions:     ["lisp", "cl"],
        git_url:        "https://github.com/theHamsta/tree-sitter-commonlisp",
        git_rev:        "32323509b3d9fe96607d151c2da2c9009eb13a2f",
        git_branch:     "master",
        ffi_func:       "tree_sitter_commonlisp",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "cooklang",
        extensions:     ["cook"],
        git_url:        "https://github.com/addcninblue/tree-sitter-cooklang",
        git_rev:        "4ebe237c1cf64cf3826fc249e9ec0988fe07e58e",
        git_branch:     nil,
        ffi_func:       "tree_sitter_cooklang",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "corn",
        extensions:     ["corn"],
        git_url:        "https://github.com/jakestanger/tree-sitter-corn",
        git_rev:        "464654742cbfd3a3de560aba120998f1d5dfa844",
        git_branch:     nil,
        ffi_func:       "tree_sitter_corn",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "cpon",
        extensions:     ["cpon"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-cpon",
        git_rev:        "594289eadfec719198e560f9d7fd243c4db678d5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_cpon",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "cpp",
        extensions:     ["cpp", "cxx", "cc", "hpp", "hxx"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-cpp",
        git_rev:        "8b5b49eb196bec7040441bee33b2c9a4838d6967",
        git_branch:     "master",
        ffi_func:       "tree_sitter_cpp",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "crystal",
        extensions:     ["cr"],
        git_url:        "https://github.com/keidax/tree-sitter-crystal",
        git_rev:        "51ad1411de9414b4600227553bb70953c352a627",
        git_branch:     nil,
        ffi_func:       "tree_sitter_crystal",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "csharp",
        extensions:     ["cs"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-c-sharp",
        git_rev:        "af29416d729b7a6603101b513604392d8f675e3b",
        git_branch:     "master",
        ffi_func:       "tree_sitter_c_sharp",
        c_symbol:       "c_sharp",
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "css",
        extensions:     ["css"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-css",
        git_rev:        "dda5cfc5722c429eaba1c910ca32c2c0c5bb1a3f",
        git_branch:     "master",
        ffi_func:       "tree_sitter_css",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "cst",
        extensions:     ["cst"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-cst",
        git_rev:        "d58f8a6a4fb60789fab750e86b1976cffc1528e1",
        git_branch:     nil,
        ffi_func:       "tree_sitter_cst",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "csv",
        extensions:     ["csv"],
        git_url:        "https://github.com/amaanq/tree-sitter-csv",
        git_rev:        "f6bf6e35eb0b95fbadea4bb39cb9709507fcb181",
        git_branch:     "master",
        ffi_func:       "tree_sitter_csv",
        c_symbol:       nil,
        directory:      "csv",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "cuda",
        extensions:     ["cu", "cuda"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-cuda",
        git_rev:        "48b066f334f4cf2174e05a50218ce2ed98b6fd01",
        git_branch:     nil,
        ffi_func:       "tree_sitter_cuda",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "cue",
        extensions:     ["cue"],
        git_url:        "https://github.com/eonpatapon/tree-sitter-cue",
        git_rev:        "dd7b90e0770ff18070c515937ba3c3d6d93db00e",
        git_branch:     nil,
        ffi_func:       "tree_sitter_cue",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "cylc",
        extensions:     ["cylc"],
        git_url:        "https://github.com/elliotfontaine/tree-sitter-cylc",
        git_rev:        "6d1d81137112299324b526477ce1db989ab58fb8",
        git_branch:     nil,
        ffi_func:       "tree_sitter_cylc",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "d",
        extensions:     ["d"],
        git_url:        "https://github.com/gdamore/tree-sitter-d",
        git_rev:        "64f27931b4e6fdd75af1102c79bacbca68a8dacc",
        git_branch:     nil,
        ffi_func:       "tree_sitter_d",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "dart",
        extensions:     ["dart"],
        git_url:        "https://github.com/UserNobody14/tree-sitter-dart",
        git_rev:        "a9bdfa3db2fbc9b9f12c93450d04a671f33a5102",
        git_branch:     "master",
        ffi_func:       "tree_sitter_dart",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "desktop",
        extensions:     ["desktop"],
        git_url:        "https://github.com/ValdezFOmar/tree-sitter-desktop",
        git_rev:        "954da7259e0f6c3bb4f811fddce11eb5ac94d9f6",
        git_branch:     nil,
        ffi_func:       "tree_sitter_desktop",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "devicetree",
        extensions:     ["dts", "dtsi"],
        git_url:        "https://github.com/joelspadin/tree-sitter-devicetree",
        git_rev:        "e78bf56f206cb47bee28a217423acb651e076848",
        git_branch:     nil,
        ffi_func:       "tree_sitter_devicetree",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "dhall",
        extensions:     ["dhall"],
        git_url:        "https://github.com/jbellerb/tree-sitter-dhall",
        git_rev:        "62013259b26ac210d5de1abf64cf1b047ef88000",
        git_branch:     nil,
        ffi_func:       "tree_sitter_dhall",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "diff",
        extensions:     ["diff", "patch"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-diff",
        git_rev:        "2520c3f934b3179bb540d23e0ef45f75304b5fed",
        git_branch:     nil,
        ffi_func:       "tree_sitter_diff",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "djot",
        extensions:     ["dj"],
        git_url:        "https://github.com/treeman/tree-sitter-djot",
        git_rev:        "759a61896ccb2200a4becec4443e768638a21d58",
        git_branch:     nil,
        ffi_func:       "tree_sitter_djot",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "dockerfile",
        extensions:     ["dockerfile"],
        git_url:        "https://github.com/camdencheek/tree-sitter-dockerfile",
        git_rev:        "971acdd908568b4531b0ba28a445bf0bb720aba5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_dockerfile",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "dot",
        extensions:     ["dot", "gv"],
        git_url:        "https://github.com/rydesun/tree-sitter-dot",
        git_rev:        "80327abbba6f47530edeb0df9f11bd5d5c93c14d",
        git_branch:     nil,
        ffi_func:       "tree_sitter_dot",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "doxygen",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-doxygen",
        git_rev:        "ccd998f378c3f9345ea4eeb223f56d7b84d16687",
        git_branch:     "master",
        ffi_func:       "tree_sitter_doxygen",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "dtd",
        extensions:     ["dtd"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-xml",
        git_rev:        "5000ae8f22d11fbe93939b05c1e37cf21117162d",
        git_branch:     nil,
        ffi_func:       "tree_sitter_dtd",
        c_symbol:       nil,
        directory:      "dtd",
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "earthfile",
        extensions:     [] of String,
        git_url:        "https://github.com/glehmann/tree-sitter-earthfile",
        git_rev:        "5baef88717ad0156fd29a8b12d0d8245bb1096a8",
        git_branch:     nil,
        ffi_func:       "tree_sitter_earthfile",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "ebnf",
        extensions:     ["ebnf"],
        git_url:        "https://github.com/RubixDev/ebnf",
        git_rev:        "8e635b0b723c620774dfb8abf382a7f531894b40",
        git_branch:     nil,
        ffi_func:       "tree_sitter_ebnf",
        c_symbol:       nil,
        directory:      "crates/tree-sitter-ebnf",
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "editorconfig",
        extensions:     [] of String,
        git_url:        "https://github.com/ValdezFOmar/tree-sitter-editorconfig",
        git_rev:        "9d843ad4cf118e007792de26d7f173c670a4fbd6",
        git_branch:     nil,
        ffi_func:       "tree_sitter_editorconfig",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "eds",
        extensions:     ["eds"],
        git_url:        "https://github.com/uyha/tree-sitter-eds",
        git_rev:        "26d529e6cfecde391a03c21d1474eb51e0285805",
        git_branch:     nil,
        ffi_func:       "tree_sitter_eds",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "eex",
        extensions:     ["eex", "leex"],
        git_url:        "https://github.com/connorlay/tree-sitter-eex",
        git_rev:        "f742f2fe327463335e8671a87c0b9b396905d1d1",
        git_branch:     nil,
        ffi_func:       "tree_sitter_eex",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "elisp",
        extensions:     ["el"],
        git_url:        "https://github.com/Wilfred/tree-sitter-elisp",
        git_rev:        "29b4e49275f4a947ce17c8533bc20a1f97768c70",
        git_branch:     nil,
        ffi_func:       "tree_sitter_elisp",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "elixir",
        extensions:     ["ex", "exs"],
        git_url:        "https://github.com/elixir-lang/tree-sitter-elixir",
        git_rev:        "c4f9f5a15ddad8635ba59a5b99c2e9124e74ad91",
        git_branch:     nil,
        ffi_func:       "tree_sitter_elixir",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "elm",
        extensions:     ["elm"],
        git_url:        "https://github.com/razzeee/tree-sitter-elm",
        git_rev:        "6d9511c28181db66daee4e883f811f6251220943",
        git_branch:     nil,
        ffi_func:       "tree_sitter_elm",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "elsa",
        extensions:     ["lc"],
        git_url:        "https://github.com/glapa-grossklag/tree-sitter-elsa",
        git_rev:        "0a66b2b3f3c1915e67ad2ef9f7dbd2a84820d9d7",
        git_branch:     nil,
        ffi_func:       "tree_sitter_elsa",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "elvish",
        extensions:     ["elv"],
        git_url:        "https://github.com/elves/tree-sitter-elvish",
        git_rev:        "5e7210d945425b77f82cbaebc5af4dd3e1ad40f5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_elvish",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "embeddedtemplate",
        extensions:     ["erb"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-embedded-template",
        git_rev:        "3499d85f0a0d937c507a4a65368f2f63772786e1",
        git_branch:     "master",
        ffi_func:       "tree_sitter_embedded_template",
        c_symbol:       "embedded_template",
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "enforce",
        extensions:     ["enforce"],
        git_url:        "https://github.com/simonvic/tree-sitter-enforce",
        git_rev:        "cb42835385ac6d4fc64fd7b3f962591b928ccc7d",
        git_branch:     nil,
        ffi_func:       "tree_sitter_enforce",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "erlang",
        extensions:     ["erl", "hrl"],
        git_url:        "https://github.com/WhatsApp/tree-sitter-erlang",
        git_rev:        "836aa2b6c3af2c7cef3f84049b0ed6d44485a870",
        git_branch:     nil,
        ffi_func:       "tree_sitter_erlang",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "facility",
        extensions:     ["fsd"],
        git_url:        "https://github.com/FacilityApi/tree-sitter-facility",
        git_rev:        "e4bfd3e960de9f4b4648acb1c92e9b95b47d8cfb",
        git_branch:     nil,
        ffi_func:       "tree_sitter_facility",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "faust",
        extensions:     ["dsp"],
        git_url:        "https://github.com/khiner/tree-sitter-faust",
        git_rev:        "2bd027f18927d13afdfdfc3f1e7088aaa515691f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_faust",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "fennel",
        extensions:     ["fnl"],
        git_url:        "https://github.com/TravonteD/tree-sitter-fennel",
        git_rev:        "36eb796a84b4f57bdf159d0a99267260d4960c89",
        git_branch:     "master",
        ffi_func:       "tree_sitter_fennel",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "fidl",
        extensions:     ["fidl"],
        git_url:        "https://github.com/google/tree-sitter-fidl",
        git_rev:        "0a8910f293268e27ff554357c229ba172b0eaed2",
        git_branch:     nil,
        ffi_func:       "tree_sitter_fidl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "firrtl",
        extensions:     ["fir"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-firrtl",
        git_rev:        "8503d3a0fe0f9e427863cb0055699ff2d29ae5f5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_firrtl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "fish",
        extensions:     ["fish"],
        git_url:        "https://github.com/ram02z/tree-sitter-fish",
        git_rev:        "f435b0bd772578c70e5d158b85267bb886316f88",
        git_branch:     "master",
        ffi_func:       "tree_sitter_fish",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "foam",
        extensions:     [] of String,
        git_url:        "https://github.com/FoamScience/tree-sitter-foam",
        git_rev:        "472c24f11a547820327fb1be565bcfff98ea96a4",
        git_branch:     nil,
        ffi_func:       "tree_sitter_foam",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "forth",
        extensions:     ["fth", "4th"],
        git_url:        "https://github.com/AlexanderBrevig/tree-sitter-forth",
        git_rev:        "7190f2173060d19a2174c96bfb5b7c6f9745512b",
        git_branch:     nil,
        ffi_func:       "tree_sitter_forth",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "fortran",
        extensions:     ["f90", "f95", "f03", "f08", "f"],
        git_url:        "https://github.com/stadelmanma/tree-sitter-fortran",
        git_rev:        "7edacd2b21aa80057d9725384a1304a1c758e0f8",
        git_branch:     "master",
        ffi_func:       "tree_sitter_fortran",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "fsharp",
        extensions:     ["fs", "fsx"],
        git_url:        "https://github.com/ionide/tree-sitter-fsharp",
        git_rev:        "7f8939ea99ef45e576156fc18b9ddef153cc13cb",
        git_branch:     "main",
        ffi_func:       "tree_sitter_fsharp",
        c_symbol:       nil,
        directory:      "fsharp",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "fsharp_signature",
        extensions:     ["fsi"],
        git_url:        "https://github.com/ionide/tree-sitter-fsharp",
        git_rev:        "7f8939ea99ef45e576156fc18b9ddef153cc13cb",
        git_branch:     "main",
        ffi_func:       "tree_sitter_fsharp_signature",
        c_symbol:       nil,
        directory:      "fsharp_signature",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "func",
        extensions:     ["fc"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-func",
        git_rev:        "f780ca55e65e7d7360d0229331763e16c452fc98",
        git_branch:     nil,
        ffi_func:       "tree_sitter_func",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gap",
        extensions:     ["g", "gi"],
        git_url:        "https://github.com/gap-system/tree-sitter-gap",
        git_rev:        "96fe2e49745ecd62b80cd19dca01fb52b83f93a1",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gap",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gdscript",
        extensions:     ["gd"],
        git_url:        "https://github.com/PrestonKnopp/tree-sitter-gdscript",
        git_rev:        "495cf07da02e5381f8147645c080bc56a13d8655",
        git_branch:     "master",
        ffi_func:       "tree_sitter_gdscript",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gdshader",
        extensions:     ["gdshader"],
        git_url:        "https://github.com/airblast-dev/tree-sitter-gdshader",
        git_rev:        "68268631c8b6dc093985f1246b099f81b30ea7d1",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gdshader",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "git_config",
        extensions:     [] of String,
        git_url:        "https://github.com/the-mikedavis/tree-sitter-git-config",
        git_rev:        "0fbc9f99d5a28865f9de8427fb0672d66f9d83a5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_git_config",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "git_rebase",
        extensions:     [] of String,
        git_url:        "https://github.com/the-mikedavis/tree-sitter-git-rebase",
        git_rev:        "32686d6b72980b36f876ae2d07719c9c3ed154e2",
        git_branch:     nil,
        ffi_func:       "tree_sitter_git_rebase",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gitattributes",
        extensions:     ["gitattributes"],
        git_url:        "https://github.com/ObserverOfTime/tree-sitter-gitattributes",
        git_rev:        "1b7af09d45b579f9f288453b95ad555f1f431645",
        git_branch:     "master",
        ffi_func:       "tree_sitter_gitattributes",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gitcommit",
        extensions:     [] of String,
        git_url:        "https://github.com/gbprod/tree-sitter-gitcommit",
        git_rev:        "49715a9e6f19ce3d33b875aacdd6ad8ddaee0ffe",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gitcommit",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gitignore",
        extensions:     ["gitignore"],
        git_url:        "https://github.com/shunsambongi/tree-sitter-gitignore",
        git_rev:        "f4685bf11ac466dd278449bcfe5fd014e94aa504",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gitignore",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gherkin",
        extensions:     ["feature"],
        git_url:        "https://github.com/SamyAB/tree-sitter-gherkin",
        git_rev:        "43873ee8de16476635b48d52c46f5b6407cb5c09",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gherkin",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gleam",
        extensions:     ["gleam"],
        git_url:        "https://github.com/gleam-lang/tree-sitter-gleam",
        git_rev:        "c610c282ef73f830d80c1f0999dce8e83f024ef5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gleam",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "glimmer",
        extensions:     ["hbs"],
        git_url:        "https://github.com/ember-tooling/tree-sitter-glimmer",
        git_rev:        "c67a73679db2945a686ca45d3e5318d86138e72a",
        git_branch:     nil,
        ffi_func:       "tree_sitter_glimmer",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "glsl",
        extensions:     ["glsl"],
        git_url:        "https://github.com/theHamsta/tree-sitter-glsl",
        git_rev:        "24a6c8ef698e4480fecf8340d771fbcb5de8fbb4",
        git_branch:     "master",
        ffi_func:       "tree_sitter_glsl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gn",
        extensions:     ["gn", "gni"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-gn",
        git_rev:        "bc06955bc1e3c9ff8e9b2b2a55b38b94da923c05",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gn",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gnuplot",
        extensions:     ["gp", "gnuplot", "plt"],
        git_url:        "https://github.com/dpezto/tree-sitter-gnuplot",
        git_rev:        "20a98295a52caa5f474839838a800d250e8fe1f4",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gnuplot",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "go",
        extensions:     ["go"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-go",
        git_rev:        "2346a3ab1bb3857b48b29d779a1ef9799a248cd7",
        git_branch:     "master",
        ffi_func:       "tree_sitter_go",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "godot_resource",
        extensions:     ["tres", "tscn"],
        git_url:        "https://github.com/PrestonKnopp/tree-sitter-godot-resource",
        git_rev:        "302c1895f54bf74d53a08572f7b26a6614209adc",
        git_branch:     nil,
        ffi_func:       "tree_sitter_godot_resource",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gomod",
        extensions:     ["mod"],
        git_url:        "https://github.com/camdencheek/tree-sitter-go-mod",
        git_rev:        "2e886870578eeba1927a2dc4bd2e2b3f598c5f9a",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gomod",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gosum",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-go-sum",
        git_rev:        "27816eb6b7315746ae9fcf711e4e1396dc1cf237",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gosum",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gotmpl",
        extensions:     ["gotmpl"],
        git_url:        "https://github.com/ngalaiko/tree-sitter-go-template",
        git_rev:        "aa71f63de226c5592dfbfc1f29949522d7c95fac",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gotmpl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gowork",
        extensions:     [] of String,
        git_url:        "https://github.com/omertuc/tree-sitter-go-work",
        git_rev:        "949a8a470559543857a62102c84700d291fc984c",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gowork",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gpg",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-gpg-config",
        git_rev:        "4024eb268c59204280f8ac71ef146b8ff5e737f6",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gpg",
        c_symbol:       "gpg",
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "graphql",
        extensions:     ["graphql", "gql"],
        git_url:        "https://github.com/bkegley/tree-sitter-graphql",
        git_rev:        "5e66e961eee421786bdda8495ed1db045e06b5fe",
        git_branch:     nil,
        ffi_func:       "tree_sitter_graphql",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gren",
        extensions:     ["gren"],
        git_url:        "https://github.com/gren-lang/tree-sitter-gren",
        git_rev:        "cecd8ce9b18f1803d37682f33b6224978fd04d31",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gren",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "groovy",
        extensions:     ["groovy", "gradle"],
        git_url:        "https://github.com/Decodetalkers/tree-sitter-groovy",
        git_rev:        "a6cf8f80dd3d5246398ad4011c2e2caf995ee17f",
        git_branch:     "gh-pages",
        ffi_func:       "tree_sitter_groovy",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "gstlaunch",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-gstlaunch",
        git_rev:        "549aef253fd38a53995cda1bf55c501174372bf7",
        git_branch:     nil,
        ffi_func:       "tree_sitter_gstlaunch",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "hack",
        extensions:     ["hack"],
        git_url:        "https://github.com/slackhq/tree-sitter-hack",
        git_rev:        "1a7ded90288189746c54861ac144ede97df95081",
        git_branch:     nil,
        ffi_func:       "tree_sitter_hack",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "hare",
        extensions:     ["hare"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-hare",
        git_rev:        "eed7ddf6a66b596906aa8ca3d40521b8278adc6f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_hare",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "haskell",
        extensions:     ["hs"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-haskell",
        git_rev:        "0975ef72fc3c47b530309ca93937d7d143523628",
        git_branch:     nil,
        ffi_func:       "tree_sitter_haskell",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "haxe",
        extensions:     ["hx"],
        git_url:        "https://github.com/vantreeseba/tree-sitter-haxe",
        git_rev:        "f2a2394d9ca7a6099f78d8b0d178530e7c9a8e26",
        git_branch:     nil,
        ffi_func:       "tree_sitter_haxe",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "hcl",
        extensions:     ["hcl"],
        git_url:        "https://github.com/MichaHoffmann/tree-sitter-hcl",
        git_rev:        "64ad62785d442eb4d45df3a1764962dafd5bc98b",
        git_branch:     nil,
        ffi_func:       "tree_sitter_hcl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "heex",
        extensions:     ["heex"],
        git_url:        "https://github.com/phoenixframework/tree-sitter-heex",
        git_rev:        "5842537f734d7c12685bf27d6005313e3e5a47a0",
        git_branch:     nil,
        ffi_func:       "tree_sitter_heex",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "hjson",
        extensions:     ["hjson"],
        git_url:        "https://github.com/winston0410/tree-sitter-hjson",
        git_rev:        "02fa3b79b3ff9a296066da6277adfc3f26cbc9e0",
        git_branch:     nil,
        ffi_func:       "tree_sitter_hjson",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "hlsl",
        extensions:     ["hlsl"],
        git_url:        "https://github.com/theHamsta/tree-sitter-hlsl",
        git_rev:        "bab9111922d53d43668fabb61869bec51bbcb915",
        git_branch:     "master",
        ffi_func:       "tree_sitter_hlsl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "hocon",
        extensions:     ["hocon"],
        git_url:        "https://github.com/antosha417/tree-sitter-hocon",
        git_rev:        "c390f10519ae69fdb03b3e5764f5592fb6924bcc",
        git_branch:     nil,
        ffi_func:       "tree_sitter_hocon",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "hoon",
        extensions:     ["hoon"],
        git_url:        "https://github.com/urbit-pilled/tree-sitter-hoon",
        git_rev:        "1545137aadcc63660c47db9ad98d02fa602655d0",
        git_branch:     nil,
        ffi_func:       "tree_sitter_hoon",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "html",
        extensions:     ["html", "htm"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-html",
        git_rev:        "73a3947324f6efddf9e17c0ea58d454843590cc0",
        git_branch:     "master",
        ffi_func:       "tree_sitter_html",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "htmldjango",
        extensions:     [] of String,
        git_url:        "https://github.com/interdependence/tree-sitter-htmldjango",
        git_rev:        "a10318892603d9a0b925df7cc7771a840304b997",
        git_branch:     nil,
        ffi_func:       "tree_sitter_htmldjango",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "http",
        extensions:     ["http"],
        git_url:        "https://github.com/rest-nvim/tree-sitter-http",
        git_rev:        "db8b4398de90b6d0b6c780aba96aaa2cd8e9202c",
        git_branch:     nil,
        ffi_func:       "tree_sitter_http",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "hurl",
        extensions:     ["hurl"],
        git_url:        "https://github.com/pfeiferj/tree-sitter-hurl",
        git_rev:        "597efbd7ce9a814bb058f48eabd055b1d1e12145",
        git_branch:     nil,
        ffi_func:       "tree_sitter_hurl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "hyprlang",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-hyprlang",
        git_rev:        "cecd6b748107d9da1f7b4ca03ef95f1f71d93b8f",
        git_branch:     "master",
        ffi_func:       "tree_sitter_hyprlang",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "idris",
        extensions:     ["idr"],
        git_url:        "https://github.com/kayhide/tree-sitter-idris",
        git_rev:        "c56a25cf57c68ff929356db25505c1cc4c7820f6",
        git_branch:     nil,
        ffi_func:       "tree_sitter_idris",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "ini",
        extensions:     ["ini", "cfg"],
        git_url:        "https://github.com/justinmk/tree-sitter-ini",
        git_rev:        "e4018b5176132b4f3c5d6e61cea383f42288d0f5",
        git_branch:     "master",
        ffi_func:       "tree_sitter_ini",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "ispc",
        extensions:     ["ispc"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-ispc",
        git_rev:        "ba1bb38ac8ddfa6aa7571cbfe9b4d029f7f77447",
        git_branch:     nil,
        ffi_func:       "tree_sitter_ispc",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "jai",
        extensions:     ["jai"],
        git_url:        "https://github.com/constantitus/tree-sitter-jai",
        git_rev:        "c61176d276761e6ee44a86b018446a1608b47b99",
        git_branch:     nil,
        ffi_func:       "tree_sitter_jai",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "janet",
        extensions:     ["janet"],
        git_url:        "https://github.com/GrayJack/tree-sitter-janet",
        git_rev:        "64db751b233ba44ce06fa6c729701bdf87779011",
        git_branch:     "master",
        ffi_func:       "tree_sitter_janet",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "java",
        extensions:     ["java"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-java",
        git_rev:        "e10607b45ff745f5f876bfa3e94fbcc6b44bdc11",
        git_branch:     "master",
        ffi_func:       "tree_sitter_java",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "javadoc",
        extensions:     [] of String,
        git_url:        "https://github.com/rmuir/tree-sitter-javadoc",
        git_rev:        "ec2814bb4c6b7f532f03f247b11caf42f29dea40",
        git_branch:     nil,
        ffi_func:       "tree_sitter_javadoc",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "javascript",
        extensions:     ["js", "jsx", "mjs", "cjs"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-javascript",
        git_rev:        "58404d8cf191d69f2674a8fd507bd5776f46cb11",
        git_branch:     "master",
        ffi_func:       "tree_sitter_javascript",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "jinja2",
        extensions:     ["j2", "jinja2"],
        git_url:        "https://github.com/dbt-labs/tree-sitter-jinja2",
        git_rev:        "a82ed374f4cb58a1358dd6b26a7157bde1bca3b7",
        git_branch:     nil,
        ffi_func:       "tree_sitter_jinja2",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "jq",
        extensions:     ["jq"],
        git_url:        "https://github.com/flurie/tree-sitter-jq",
        git_rev:        "c204e36d2c3c6fce1f57950b12cabcc24e5cc4d9",
        git_branch:     nil,
        ffi_func:       "tree_sitter_jq",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "jsdoc",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter/tree-sitter-jsdoc",
        git_rev:        "658d18dcdddb75c760363faa4963427a7c6b52db",
        git_branch:     "master",
        ffi_func:       "tree_sitter_jsdoc",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "json",
        extensions:     ["json"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-json",
        git_rev:        "001c28d7a29832b06b0e831ec77845553c89b56d",
        git_branch:     "master",
        ffi_func:       "tree_sitter_json",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     true,
      },
      {
        name:           "json5",
        extensions:     ["json5"],
        git_url:        "https://github.com/Joakker/tree-sitter-json5",
        git_rev:        "248b8564567087d7866be76569b182f6dd7e14e9",
        git_branch:     nil,
        ffi_func:       "tree_sitter_json5",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "jsonnet",
        extensions:     ["jsonnet", "libsonnet"],
        git_url:        "https://github.com/sourcegraph/tree-sitter-jsonnet",
        git_rev:        "ddd075f1939aed8147b7aa67f042eda3fce22790",
        git_branch:     nil,
        ffi_func:       "tree_sitter_jsonnet",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "julia",
        extensions:     ["jl"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-julia",
        git_rev:        "e0f9dcd180fdcfcfa8d79a3531e11d99e79321d3",
        git_branch:     "master",
        ffi_func:       "tree_sitter_julia",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "just",
        extensions:     ["just"],
        git_url:        "https://github.com/IndianBoy42/tree-sitter-just",
        git_rev:        "5685543a6e64f66335e25518c9ae8ffa1dae3d01",
        git_branch:     nil,
        ffi_func:       "tree_sitter_just",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "kcl",
        extensions:     ["k"],
        git_url:        "https://github.com/kcl-lang/tree-sitter-kcl",
        git_rev:        "026f40fb0a59a35da75b9c8801d52f6c14feda24",
        git_branch:     nil,
        ffi_func:       "tree_sitter_kcl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "kconfig",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-kconfig",
        git_rev:        "9ac99fe4c0c27a35dc6f757cef534c646e944881",
        git_branch:     nil,
        ffi_func:       "tree_sitter_kconfig",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "kdl",
        extensions:     ["kdl"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-kdl",
        git_rev:        "b37e3d58e5c5cf8d739b315d6114e02d42e66664",
        git_branch:     nil,
        ffi_func:       "tree_sitter_kdl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "kotlin",
        extensions:     ["kt", "kts"],
        git_url:        "https://github.com/fwcd/tree-sitter-kotlin",
        git_rev:        "c8ac3d2627240160b999a2c100de3babbdb8f419",
        git_branch:     nil,
        ffi_func:       "tree_sitter_kotlin",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "latex",
        extensions:     ["tex"],
        git_url:        "https://github.com/latex-lsp/tree-sitter-latex",
        git_rev:        "7e0ecdc02926c7b9b2e0c76003d4fe7b0944f957",
        git_branch:     "master",
        ffi_func:       "tree_sitter_latex",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "lean",
        extensions:     ["lean"],
        git_url:        "https://github.com/Julian/tree-sitter-lean",
        git_rev:        "dc5997b2744595eeb389e1ed9c4f5e727c5b655e",
        git_branch:     nil,
        ffi_func:       "tree_sitter_lean",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "ledger",
        extensions:     ["ldg", "ledger", "journal"],
        git_url:        "https://github.com/cbarrete/tree-sitter-ledger",
        git_rev:        "22a1ab8195c1f6e808679f803007756fe7638c6f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_ledger",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "less",
        extensions:     ["less"],
        git_url:        "https://github.com/rhino1998/tree-sitter-less",
        git_rev:        "2bd739e106a3485bca210cf7b6d25ba09fd10dff",
        git_branch:     nil,
        ffi_func:       "tree_sitter_less",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "linkerscript",
        extensions:     ["lds"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-linkerscript",
        git_rev:        "f99011a3554213b654985a4b0a65b3b032ec4621",
        git_branch:     nil,
        ffi_func:       "tree_sitter_linkerscript",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "liquid",
        extensions:     ["liquid"],
        git_url:        "https://github.com/hankthetank27/tree-sitter-liquid",
        git_rev:        "e45dbac8c5fa95b1f0e00e7e0c04bc8855823391",
        git_branch:     nil,
        ffi_func:       "tree_sitter_liquid",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "llvm",
        extensions:     ["ll"],
        git_url:        "https://github.com/benwilliamgraham/tree-sitter-llvm",
        git_rev:        "2914786ae6774d4c4e25a230f4afe16aa68fe1c1",
        git_branch:     nil,
        ffi_func:       "tree_sitter_llvm",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "lua",
        extensions:     ["lua"],
        git_url:        "https://github.com/MunifTanjim/tree-sitter-lua",
        git_rev:        "4fbec840c34149b7d5fe10097c93a320ee4af053",
        git_branch:     nil,
        ffi_func:       "tree_sitter_lua",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "luadoc",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-luadoc",
        git_rev:        "873612aadd3f684dd4e631bdf42ea8990c57634e",
        git_branch:     nil,
        ffi_func:       "tree_sitter_luadoc",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "luap",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-luap",
        git_rev:        "c134aaec6acf4fa95fe4aa0dc9aba3eacdbbe55a",
        git_branch:     nil,
        ffi_func:       "tree_sitter_luap",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "luau",
        extensions:     ["luau"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-luau",
        git_rev:        "a8914d6c1fc5131f8e1c13f769fa704c9f5eb02f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_luau",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "magik",
        extensions:     ["magik"],
        git_url:        "https://github.com/krn-robin/tree-sitter-magik",
        git_rev:        "3a7e53e91938de7c6f356fc5249d23fdc353a80a",
        git_branch:     nil,
        ffi_func:       "tree_sitter_magik",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "make",
        extensions:     ["mk", "makefile"],
        git_url:        "https://github.com/alemuller/tree-sitter-make",
        git_rev:        "a4b9187417d6be349ee5fd4b6e77b4172c6827dd",
        git_branch:     nil,
        ffi_func:       "tree_sitter_make",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "markdown",
        extensions:     ["md", "markdown"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-markdown",
        git_rev:        "c3570720f7f7bbad22fe96603f106276618e0cf5",
        git_branch:     "split_parser",
        ffi_func:       "tree_sitter_markdown",
        c_symbol:       nil,
        directory:      "tree-sitter-markdown",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "markdown_inline",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-markdown",
        git_rev:        "c3570720f7f7bbad22fe96603f106276618e0cf5",
        git_branch:     "split_parser",
        ffi_func:       "tree_sitter_markdown_inline",
        c_symbol:       nil,
        directory:      "tree-sitter-markdown-inline",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "matlab",
        extensions:     ["matlab"],
        git_url:        "https://github.com/acristoffers/tree-sitter-matlab",
        git_rev:        "c9ef947ec67fb6b500d5def4f5e09b56990a9f91",
        git_branch:     nil,
        ffi_func:       "tree_sitter_matlab",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "mermaid",
        extensions:     ["mmd", "mermaid"],
        git_url:        "https://github.com/monaqa/tree-sitter-mermaid",
        git_rev:        "90ae195b31933ceb9d079abfa8a3ad0a36fee4cc",
        git_branch:     "master",
        ffi_func:       "tree_sitter_mermaid",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "meson",
        extensions:     ["meson"],
        git_url:        "https://github.com/Decodetalkers/tree-sitter-meson",
        git_rev:        "aa8d472034956f94f51f2ef2cbfec4cc07efbfde",
        git_branch:     "master",
        ffi_func:       "tree_sitter_meson",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "mlir",
        extensions:     ["mlir"],
        git_url:        "https://github.com/artagnon/tree-sitter-mlir",
        git_rev:        "48cb6b8b75b2cd0be1b6027e17da349da6711119",
        git_branch:     nil,
        ffi_func:       "tree_sitter_mlir",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "mojo",
        extensions:     ["mojo"],
        git_url:        "https://github.com/HerringtonDarkholme/tree-sitter-mojo",
        git_rev:        "99fe918e69f087f910ef3b11eba31eb0d7e54edf",
        git_branch:     nil,
        ffi_func:       "tree_sitter_mojo",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "move",
        extensions:     ["move"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-move",
        git_rev:        "b8ca25518749be10562455fd081a3dab30b93b8b",
        git_branch:     nil,
        ffi_func:       "tree_sitter_move",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "nasm",
        extensions:     ["nasm"],
        git_url:        "https://github.com/naclsn/tree-sitter-nasm",
        git_rev:        "d1b3638d017f2a8585e26dcfc66fe1df94185e30",
        git_branch:     nil,
        ffi_func:       "tree_sitter_nasm",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "netlinx",
        extensions:     ["axs", "axi"],
        git_url:        "https://github.com/Norgate-AV/tree-sitter-netlinx",
        git_rev:        "1c166a97a3481f385136394b950d9556d28af7b8",
        git_branch:     nil,
        ffi_func:       "tree_sitter_netlinx",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "nginx",
        extensions:     ["conf", "nginx"],
        git_url:        "https://github.com/opa-oz/tree-sitter-nginx",
        git_rev:        "47ade644d754cce57974aac44d2c9450e823d4f4",
        git_branch:     nil,
        ffi_func:       "tree_sitter_nginx",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "nickel",
        extensions:     ["ncl"],
        git_url:        "https://github.com/nickel-lang/tree-sitter-nickel",
        git_rev:        "3252ec6a65c7e4c3ca6ef3e3be0160111b93fbd7",
        git_branch:     nil,
        ffi_func:       "tree_sitter_nickel",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "nim",
        extensions:     ["nim", "nims"],
        git_url:        "https://github.com/aMOPel/tree-sitter-nim",
        git_rev:        "4900b68ead86049b67c4f7dfc4a805f170a7970e",
        git_branch:     nil,
        ffi_func:       "tree_sitter_nim",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "ninja",
        extensions:     ["ninja"],
        git_url:        "https://github.com/alemuller/tree-sitter-ninja",
        git_rev:        "0a95cfdc0745b6ae82f60d3a339b37f19b7b9267",
        git_branch:     nil,
        ffi_func:       "tree_sitter_ninja",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "nix",
        extensions:     ["nix"],
        git_url:        "https://github.com/nix-community/tree-sitter-nix",
        git_rev:        "3d0173d903e630b6e14d17f1cf79488791379ded",
        git_branch:     "master",
        ffi_func:       "tree_sitter_nix",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "norg",
        extensions:     ["norg"],
        git_url:        "https://github.com/nvim-neorg/tree-sitter-norg",
        git_rev:        "d7edfaf89198aab652c7a1f0f818196efedaccfb",
        git_branch:     nil,
        ffi_func:       "tree_sitter_norg",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "norg_meta",
        extensions:     [] of String,
        git_url:        "https://github.com/nvim-neorg/tree-sitter-norg-meta",
        git_rev:        "729d4e54fb881ba0ddf0f925ec78401354c7c6db",
        git_branch:     nil,
        ffi_func:       "tree_sitter_norg_meta",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "nqc",
        extensions:     ["nqc"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-nqc",
        git_rev:        "14e6da1627aaef21d2b2aa0c37d04269766dcc1d",
        git_branch:     nil,
        ffi_func:       "tree_sitter_nqc",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "nushell",
        extensions:     ["nu"],
        git_url:        "https://github.com/nushell/tree-sitter-nu",
        git_rev:        "d694570aa26b53d0d642460a0430e8aa07dcbea0",
        git_branch:     nil,
        ffi_func:       "tree_sitter_nu",
        c_symbol:       "nu",
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "objc",
        extensions:     ["m"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-objc",
        git_rev:        "181a81b8f23a2d593e7ab4259981f50122909fda",
        git_branch:     nil,
        ffi_func:       "tree_sitter_objc",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "ocaml",
        extensions:     ["ml"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-ocaml",
        git_rev:        "527d62ef0f24ce0d97fbedf004921d75d0a7e086",
        git_branch:     "master",
        ffi_func:       "tree_sitter_ocaml",
        c_symbol:       nil,
        directory:      "grammars/ocaml",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "ocaml_interface",
        extensions:     ["mli"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-ocaml",
        git_rev:        "527d62ef0f24ce0d97fbedf004921d75d0a7e086",
        git_branch:     "master",
        ffi_func:       "tree_sitter_ocaml_interface",
        c_symbol:       nil,
        directory:      "grammars/interface",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "ocamllex",
        extensions:     ["mll"],
        git_url:        "https://github.com/atom-ocaml/tree-sitter-ocamllex",
        git_rev:        "33722b8be73079946a7c6dd9598e3f57956ed36d",
        git_branch:     nil,
        ffi_func:       "tree_sitter_ocamllex",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "odin",
        extensions:     ["odin"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-odin",
        git_rev:        "d2ca8efb4487e156a60d5bd6db2598b872629403",
        git_branch:     nil,
        ffi_func:       "tree_sitter_odin",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "openscad",
        extensions:     ["scad"],
        git_url:        "https://github.com/bollian/tree-sitter-openscad",
        git_rev:        "bb1e12023e59489c0892af0c0c9a5b323af69df6",
        git_branch:     nil,
        ffi_func:       "tree_sitter_openscad",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "org",
        extensions:     ["org"],
        git_url:        "https://github.com/milisims/tree-sitter-org",
        git_rev:        "64cfbc213f5a83da17632c95382a5a0a2f3357c1",
        git_branch:     nil,
        ffi_func:       "tree_sitter_org",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "pascal",
        extensions:     ["pas"],
        git_url:        "https://github.com/Isopod/tree-sitter-pascal",
        git_rev:        "042119eca2e18a60e56317fb06ee3ba5c32cb447",
        git_branch:     "master",
        ffi_func:       "tree_sitter_pascal",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "pem",
        extensions:     ["pem"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-pem",
        git_rev:        "e525b177a229b1154fd81bc0691f943028d9e685",
        git_branch:     nil,
        ffi_func:       "tree_sitter_pem",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "perl",
        extensions:     ["pl", "pm"],
        git_url:        "https://github.com/tree-sitter-perl/tree-sitter-perl",
        git_rev:        "0390ac6f4e26f5805c9d7d9b950685436faa6359",
        git_branch:     "release",
        ffi_func:       "tree_sitter_perl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "pgn",
        extensions:     ["pgn"],
        git_url:        "https://github.com/rolandwalker/tree-sitter-pgn",
        git_rev:        "be9cd4d91f96cb2d9e89df8a302f2fb363564f50",
        git_branch:     "master",
        ffi_func:       "tree_sitter_pgn",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "php",
        extensions:     ["php"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-php",
        git_rev:        "38216983c07bf9e1b56e16acde53b25adaeab61c",
        git_branch:     nil,
        ffi_func:       "tree_sitter_php",
        c_symbol:       nil,
        directory:      "php",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "phpdoc",
        extensions:     [] of String,
        git_url:        "https://github.com/claytonrcarter/tree-sitter-phpdoc",
        git_rev:        "12d50307e6c02e5f4f876fa6cf2edea1f7808c0d",
        git_branch:     nil,
        ffi_func:       "tree_sitter_phpdoc",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "pkl",
        extensions:     ["pkl"],
        git_url:        "https://github.com/apple/tree-sitter-pkl",
        git_rev:        "90b64cb6e563bcc96552490ccd40667418c65cdc",
        git_branch:     nil,
        ffi_func:       "tree_sitter_pkl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "po",
        extensions:     ["po", "pot"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-po",
        git_rev:        "bd860a0f57f697162bf28e576674be9c1500db5e",
        git_branch:     nil,
        ffi_func:       "tree_sitter_po",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "poe_filter",
        extensions:     ["filter"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-poe-filter",
        git_rev:        "205a7d576984feb38a9fc2d8cfe729617f9e0548",
        git_branch:     nil,
        ffi_func:       "tree_sitter_poe_filter",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "pony",
        extensions:     ["pony"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-pony",
        git_rev:        "73ff874ae4c9e9b45462673cbc0a1e350e2522a7",
        git_branch:     nil,
        ffi_func:       "tree_sitter_pony",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "postscript",
        extensions:     ["ps", "eps"],
        git_url:        "https://github.com/smoeding/tree-sitter-postscript",
        git_rev:        "d352ed652a2b39cfa1567c1b77a44e275399bacf",
        git_branch:     nil,
        ffi_func:       "tree_sitter_postscript",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "powershell",
        extensions:     ["ps1", "psm1", "psd1"],
        git_url:        "https://github.com/airbus-cert/tree-sitter-powershell",
        git_rev:        "d398441825243b00e317e87e1829b9d6a3e54ce0",
        git_branch:     nil,
        ffi_func:       "tree_sitter_powershell",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "printf",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-printf",
        git_rev:        "ec4e5674573d5554fccb87a887c97d4aec489da7",
        git_branch:     nil,
        ffi_func:       "tree_sitter_printf",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "prisma",
        extensions:     ["prisma"],
        git_url:        "https://github.com/LumaKernel/tree-sitter-prisma",
        git_rev:        "f1c30d82a5bf0b70ce33ef431f4acd7fd69968a3",
        git_branch:     "master",
        ffi_func:       "tree_sitter_prisma",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "prolog",
        extensions:     ["pro"],
        git_url:        "https://github.com/Rukiza/tree-sitter-prolog",
        git_rev:        "c246cf2bf36590a3cb4de380205376d3c46208e8",
        git_branch:     nil,
        ffi_func:       "tree_sitter_prolog",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "promql",
        extensions:     ["promql"],
        git_url:        "https://github.com/MichaHoffmann/tree-sitter-promql",
        git_rev:        "77625d78eebc3ffc44d114a07b2f348dff3061b0",
        git_branch:     nil,
        ffi_func:       "tree_sitter_promql",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "properties",
        extensions:     ["properties"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-properties",
        git_rev:        "6310671b24d4e04b803577b1c675d765cbd5773b",
        git_branch:     nil,
        ffi_func:       "tree_sitter_properties",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "proto",
        extensions:     ["proto"],
        git_url:        "https://github.com/coder3101/tree-sitter-proto",
        git_rev:        "cf8e4eba6e5b4afb9eb16c9178bba3d2504b46c2",
        git_branch:     nil,
        ffi_func:       "tree_sitter_proto",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "prql",
        extensions:     ["prql"],
        git_url:        "https://github.com/PRQL/tree-sitter-prql",
        git_rev:        "09e158cd3650581c0af4c49c2e5b10c4834c8646",
        git_branch:     nil,
        ffi_func:       "tree_sitter_prql",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "psv",
        extensions:     ["psv"],
        git_url:        "https://github.com/amaanq/tree-sitter-csv",
        git_rev:        "f6bf6e35eb0b95fbadea4bb39cb9709507fcb181",
        git_branch:     "master",
        ffi_func:       "tree_sitter_psv",
        c_symbol:       nil,
        directory:      "psv",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "pug",
        extensions:     ["pug"],
        git_url:        "https://github.com/zealot128/tree-sitter-pug",
        git_rev:        "13e9195370172c86a8b88184cc358b23b677cc46",
        git_branch:     nil,
        ffi_func:       "tree_sitter_pug",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "puppet",
        extensions:     ["pp"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-puppet",
        git_rev:        "15f192929b7d317f5914de2b4accd37b349182a6",
        git_branch:     nil,
        ffi_func:       "tree_sitter_puppet",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "purescript",
        extensions:     ["purs"],
        git_url:        "https://github.com/postsolar/tree-sitter-purescript",
        git_rev:        "f541f95ffd6852fbbe88636317c613285bc105af",
        git_branch:     nil,
        ffi_func:       "tree_sitter_purescript",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "pymanifest",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-pymanifest",
        git_rev:        "debbdb83fe6356adc7261c41c69b45ba49c97294",
        git_branch:     nil,
        ffi_func:       "tree_sitter_pymanifest",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "python",
        extensions:     ["py", "pyi", "pyw"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-python",
        git_rev:        "26855eabccb19c6abf499fbc5b8dc7cc9ab8bc64",
        git_branch:     "master",
        ffi_func:       "tree_sitter_python",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "ql",
        extensions:     ["ql"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-ql",
        git_rev:        "1fd627a4e8bff8c24c11987474bd33112bead857",
        git_branch:     nil,
        ffi_func:       "tree_sitter_ql",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "qmldir",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-qmldir",
        git_rev:        "0935b681e7f60e497f9b4d2eff19254cf1ecaa51",
        git_branch:     nil,
        ffi_func:       "tree_sitter_qmldir",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "qmljs",
        extensions:     ["qml"],
        git_url:        "https://github.com/yuja/tree-sitter-qmljs",
        git_rev:        "606a66b96a13ef30ed5c7ec7e5adc20a9a40157a",
        git_branch:     "master",
        ffi_func:       "tree_sitter_qmljs",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "query",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-query",
        git_rev:        "15e00db655cf1708cf8e4b172b2f321d9b7b98c1",
        git_branch:     nil,
        ffi_func:       "tree_sitter_query",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "r",
        extensions:     ["r"],
        git_url:        "https://github.com/r-lib/tree-sitter-r",
        git_rev:        "58a22794466c0fc15b0d3b40531db751593721e8",
        git_branch:     nil,
        ffi_func:       "tree_sitter_r",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "racket",
        extensions:     ["rkt"],
        git_url:        "https://github.com/6cdh/tree-sitter-racket",
        git_rev:        "e2b8064b32ab1dfa30532aeac1577ae4c1cc3df5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_racket",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "rasi",
        extensions:     ["rasi"],
        git_url:        "https://github.com/Fymyte/tree-sitter-rasi",
        git_rev:        "e735c6881d8b475aaa4ef8f0a2bdfd825b438143",
        git_branch:     nil,
        ffi_func:       "tree_sitter_rasi",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "razor",
        extensions:     ["razor", "cshtml"],
        git_url:        "https://github.com/tris203/tree-sitter-razor",
        git_rev:        "900f53dc6cc592f6e616adc2f732cb0f66fc9147",
        git_branch:     nil,
        ffi_func:       "tree_sitter_razor",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "rbs",
        extensions:     ["rbs"],
        git_url:        "https://github.com/joker1007/tree-sitter-rbs",
        git_rev:        "5282e2f36d4109f5315c1d9486b5b0c2044622bb",
        git_branch:     nil,
        ffi_func:       "tree_sitter_rbs",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "re2c",
        extensions:     ["re"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-re2c",
        git_rev:        "c18a3c2f4b6665e35b7e50d6048ea3cff770c572",
        git_branch:     nil,
        ffi_func:       "tree_sitter_re2c",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "readline",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-readline",
        git_rev:        "6b744c527aebd12e46a5ecb3aebdb8d621a8e83e",
        git_branch:     nil,
        ffi_func:       "tree_sitter_readline",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "regex",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter/tree-sitter-regex",
        git_rev:        "b2ac15e27fce703d2f37a79ccd94a5c0cbe9720b",
        git_branch:     "master",
        ffi_func:       "tree_sitter_regex",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "rego",
        extensions:     ["rego"],
        git_url:        "https://github.com/FallenAngel97/tree-sitter-rego",
        git_rev:        "2ed149b424b24a301e9750f1d78263212f037ac5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_rego",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "requirements",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-requirements",
        git_rev:        "2c3bb291f497258ba417d052faa14a2dfee6d401",
        git_branch:     nil,
        ffi_func:       "tree_sitter_requirements",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "rescript",
        extensions:     ["res", "resi"],
        git_url:        "https://github.com/rescript-lang/tree-sitter-rescript",
        git_rev:        "990214a83f25801dfe0226bd7e92bb71bba1970f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_rescript",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "robot",
        extensions:     ["robot"],
        git_url:        "https://github.com/Hubro/tree-sitter-robot",
        git_rev:        "3de13dcc7559223c97e6b703217bbf728e20e169",
        git_branch:     nil,
        ffi_func:       "tree_sitter_robot",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "roc",
        extensions:     ["roc"],
        git_url:        "https://github.com/faldor20/tree-sitter-roc",
        git_rev:        "68f405426d030a7625392aabf41836c1aad05d33",
        git_branch:     nil,
        ffi_func:       "tree_sitter_roc",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "ron",
        extensions:     ["ron"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-ron",
        git_rev:        "78938553b93075e638035f624973083451b29055",
        git_branch:     nil,
        ffi_func:       "tree_sitter_ron",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "rst",
        extensions:     ["rst"],
        git_url:        "https://github.com/stsewd/tree-sitter-rst",
        git_rev:        "a60f1070b824cb8bb8409b4b6d7da0d07997c30e",
        git_branch:     "master",
        ffi_func:       "tree_sitter_rst",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "rtf",
        extensions:     ["rtf"],
        git_url:        "https://github.com/GoodNotes/tree-sitter-rtf",
        git_rev:        "3bbc47cb5d991bef4ebab1118459f6c8d5064c54",
        git_branch:     nil,
        ffi_func:       "tree_sitter_rtf",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "ruby",
        extensions:     ["rb"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-ruby",
        git_rev:        "ad907a69da0c8a4f7a943a7fe012712208da6dee",
        git_branch:     "master",
        ffi_func:       "tree_sitter_ruby",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "rust",
        extensions:     ["rs"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-rust",
        git_rev:        "77a3747266f4d621d0757825e6b11edcbf991ca5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_rust",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "scala",
        extensions:     ["scala"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-scala",
        git_rev:        "4d081d98670ff6e98ca42c085294fc75eec15e1d",
        git_branch:     "master",
        ffi_func:       "tree_sitter_scala",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "scheme",
        extensions:     ["scm"],
        git_url:        "https://github.com/6cdh/tree-sitter-scheme",
        git_rev:        "c6cb7c7d7a04b3f5d999c28e2e9c0c31b2d50ece",
        git_branch:     nil,
        ffi_func:       "tree_sitter_scheme",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "scss",
        extensions:     ["scss"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-scss",
        git_rev:        "2ef6d42e3ad7a8208900f9346f4529806ae0f9f9",
        git_branch:     nil,
        ffi_func:       "tree_sitter_scss",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "slang",
        extensions:     ["slang"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-slang",
        git_rev:        "1dbcc4abc7b3cdd663eb03d93031167d6ed19f56",
        git_branch:     nil,
        ffi_func:       "tree_sitter_slang",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "smali",
        extensions:     ["smali"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-smali",
        git_rev:        "fdfa6a1febc43c7467aa7e937b87b607956f2346",
        git_branch:     nil,
        ffi_func:       "tree_sitter_smali",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "smalltalk",
        extensions:     ["st"],
        git_url:        "https://github.com/tom95/tree-sitter-smalltalk",
        git_rev:        "f5d63d37ebb135fd0eb0441a51d5ccdf933c6537",
        git_branch:     nil,
        ffi_func:       "tree_sitter_smalltalk",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "smithy",
        extensions:     ["smithy"],
        git_url:        "https://github.com/indoorvivants/tree-sitter-smithy",
        git_rev:        "ec4fe14586f2b0a1bc65d6db17f8d8acd8a90433",
        git_branch:     nil,
        ffi_func:       "tree_sitter_smithy",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "sml",
        extensions:     ["sml", "sig", "fun"],
        git_url:        "https://github.com/MatthewFluet/tree-sitter-sml",
        git_rev:        "fd4b4955bb998262840ab8119885b3edf20ea75a",
        git_branch:     nil,
        ffi_func:       "tree_sitter_sml",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "snakemake",
        extensions:     ["smk"],
        git_url:        "https://github.com/osthomas/tree-sitter-snakemake",
        git_rev:        "68010430c3e51c0e84c1ce21c6551df0e2469f51",
        git_branch:     nil,
        ffi_func:       "tree_sitter_snakemake",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "solidity",
        extensions:     ["sol"],
        git_url:        "https://github.com/JoranHonig/tree-sitter-solidity",
        git_rev:        "048fe686cb1fde267243739b8bdbec8fc3a55272",
        git_branch:     "master",
        ffi_func:       "tree_sitter_solidity",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "souffle",
        extensions:     ["dl"],
        git_url:        "https://github.com/langston-barrett/tree-sitter-souffle",
        git_rev:        "0ca94fad4422bc9a391f81418b5716e3af00ed2f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_souffle",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "sourcepawn",
        extensions:     ["sp", "inc"],
        git_url:        "https://github.com/nilshelmig/tree-sitter-sourcepawn",
        git_rev:        "5a8fdd446b516c81e218245c12129c6ad4bccfa2",
        git_branch:     nil,
        ffi_func:       "tree_sitter_sourcepawn",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "sparql",
        extensions:     ["sparql"],
        git_url:        "https://github.com/GordianDziwis/tree-sitter-sparql",
        git_rev:        "1ef52d35a73a2a5f2e433ecfd1c751c1360a923b",
        git_branch:     nil,
        ffi_func:       "tree_sitter_sparql",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "sql",
        extensions:     ["sql"],
        git_url:        "https://github.com/DerekStride/tree-sitter-sql",
        git_rev:        "c2e1e08db1ea20dc23bdb8d228a81a8756e9c450",
        git_branch:     nil,
        ffi_func:       "tree_sitter_sql",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "sql_bigquery",
        extensions:     ["bq"],
        git_url:        "https://github.com/takegue/tree-sitter-sql-bigquery",
        git_rev:        "c0c4f0ed7b87846cb1be19df5d638ca227a9fe41",
        git_branch:     nil,
        ffi_func:       "tree_sitter_sql_bigquery",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "squirrel",
        extensions:     ["squirrel", "nut"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-squirrel",
        git_rev:        "072c969749e66f000dba35a33c387650e203e96e",
        git_branch:     nil,
        ffi_func:       "tree_sitter_squirrel",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "ssh_config",
        extensions:     [] of String,
        git_url:        "https://github.com/ObserverOfTime/tree-sitter-ssh-config",
        git_rev:        "71d2693deadaca8cdc09e38ba41d2f6042da1616",
        git_branch:     nil,
        ffi_func:       "tree_sitter_ssh_config",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "stan",
        extensions:     ["stan"],
        git_url:        "https://github.com/WardBrian/tree-sitter-stan",
        git_rev:        "86544507c3600d5c4719d98ada477123fee81983",
        git_branch:     nil,
        ffi_func:       "tree_sitter_stan",
        c_symbol:       nil,
        directory:      "grammars/stan",
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "starlark",
        extensions:     ["star", "bzl"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-starlark",
        git_rev:        "a453dbf3ba433db0e5ec621a38a7e59d72e4dc69",
        git_branch:     nil,
        ffi_func:       "tree_sitter_starlark",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "superhtml",
        extensions:     ["shtml"],
        git_url:        "https://github.com/kristoff-it/superhtml",
        git_rev:        "d4d81e1ad35f8f6c060f3cb49b60c5d54a7d012a",
        git_branch:     nil,
        ffi_func:       "tree_sitter_superhtml",
        c_symbol:       nil,
        directory:      "tree-sitter-superhtml",
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "svelte",
        extensions:     ["svelte"],
        git_url:        "https://github.com/Himujjal/tree-sitter-svelte",
        git_rev:        "60ea1d673a1a3eeeb597e098d9ada9ed0c79ef4b",
        git_branch:     "master",
        ffi_func:       "tree_sitter_svelte",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "sway",
        extensions:     ["sw"],
        git_url:        "https://github.com/FuelLabs/tree-sitter-sway",
        git_rev:        "9b7845ce06ecb38b040c3940970b4fd0adc331d1",
        git_branch:     nil,
        ffi_func:       "tree_sitter_sway",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "swift",
        extensions:     ["swift"],
        git_url:        "https://github.com/alex-pinkus/tree-sitter-swift",
        git_rev:        "0c469cbb77457ebabe2702268bcf7f116b3fac8f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_swift",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "systemverilog",
        extensions:     ["sv", "svh"],
        git_url:        "https://github.com/gmlarumbe/tree-sitter-systemverilog",
        git_rev:        "5f7a4121ef40e8d38317833968fe861fd6913d28",
        git_branch:     nil,
        ffi_func:       "tree_sitter_systemverilog",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "tablegen",
        extensions:     ["td"],
        git_url:        "https://github.com/Flakebi/tree-sitter-tablegen",
        git_rev:        "3e9c4822ab5cdcccf4f8aa9dcd42117f736d51d9",
        git_branch:     "master",
        ffi_func:       "tree_sitter_tablegen",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "tact",
        extensions:     ["tact"],
        git_url:        "https://github.com/tact-lang/tree-sitter-tact",
        git_rev:        "a6267c2091ed432c248780cec9f8d42c8766d9ad",
        git_branch:     nil,
        ffi_func:       "tree_sitter_tact",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "tcl",
        extensions:     ["tcl"],
        git_url:        "https://github.com/lewis6991/tree-sitter-tcl",
        git_rev:        "8f11ac7206a54ed11210491cee1e0657e2962c47",
        git_branch:     nil,
        ffi_func:       "tree_sitter_tcl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "teal",
        extensions:     ["tl"],
        git_url:        "https://github.com/euclidianAce/tree-sitter-teal",
        git_rev:        "05d276e737055e6f77a21335b7573c9d3c091e2f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_teal",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "templ",
        extensions:     ["templ"],
        git_url:        "https://github.com/vrischmann/tree-sitter-templ",
        git_rev:        "04bae7c82de2fcfec94254fef50f5f1c5924f5f5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_templ",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "tera",
        extensions:     ["tera"],
        git_url:        "https://github.com/uncenter/tree-sitter-tera",
        git_rev:        "3a38c368e806268daac9923a27e72bcafbbc16bb",
        git_branch:     nil,
        ffi_func:       "tree_sitter_tera",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "terraform",
        extensions:     ["tf", "tfvars"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-hcl",
        git_rev:        "64ad62785d442eb4d45df3a1764962dafd5bc98b",
        git_branch:     nil,
        ffi_func:       "tree_sitter_terraform",
        c_symbol:       nil,
        directory:      "dialects/terraform",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "test",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-test",
        git_rev:        "76b419f178da018c29d3004fcbf14f755649eb58",
        git_branch:     nil,
        ffi_func:       "tree_sitter_test",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "textproto",
        extensions:     ["textproto", "pbtxt"],
        git_url:        "https://github.com/PorterAtGoogle/tree-sitter-textproto",
        git_rev:        "568471b80fd8793d37ed01865d8c2208a9fefd1b",
        git_branch:     nil,
        ffi_func:       "tree_sitter_textproto",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "thrift",
        extensions:     ["thrift"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-thrift",
        git_rev:        "68fd0d80943a828d9e6f49c58a74be1e9ca142cf",
        git_branch:     nil,
        ffi_func:       "tree_sitter_thrift",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "tlaplus",
        extensions:     ["tla"],
        git_url:        "https://github.com/tlaplus-community/tree-sitter-tlaplus",
        git_rev:        "add40814fda369f6efd989977b2c498aaddde984",
        git_branch:     nil,
        ffi_func:       "tree_sitter_tlaplus",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "tmux",
        extensions:     [] of String,
        git_url:        "https://github.com/Freed-Wu/tree-sitter-tmux",
        git_rev:        "75d1b995b0c23400ac8e49db757a2e0386f9fa8f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_tmux",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "todotxt",
        extensions:     ["todotxt"],
        git_url:        "https://github.com/arnarg/tree-sitter-todotxt",
        git_rev:        "3937c5cd105ec4127448651a21aef45f52d19609",
        git_branch:     nil,
        ffi_func:       "tree_sitter_todotxt",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "toml",
        extensions:     ["toml"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-toml",
        git_rev:        "64b56832c2cffe41758f28e05c756a3a98d16f41",
        git_branch:     "master",
        ffi_func:       "tree_sitter_toml",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "tsv",
        extensions:     ["tsv"],
        git_url:        "https://github.com/amaanq/tree-sitter-csv",
        git_rev:        "f6bf6e35eb0b95fbadea4bb39cb9709507fcb181",
        git_branch:     "master",
        ffi_func:       "tree_sitter_tsv",
        c_symbol:       nil,
        directory:      "tsv",
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "tsx",
        extensions:     ["tsx"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-typescript",
        git_rev:        "75b3874edb2dc714fb1fd77a32013d0f8699989f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_tsx",
        c_symbol:       nil,
        directory:      "tsx",
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "turtle",
        extensions:     ["ttl"],
        git_url:        "https://github.com/GordianDziwis/tree-sitter-turtle",
        git_rev:        "7f789ea7ef765080f71a298fc96b7c957fa24422",
        git_branch:     nil,
        ffi_func:       "tree_sitter_turtle",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "twig",
        extensions:     ["twig"],
        git_url:        "https://github.com/gbprod/tree-sitter-twig",
        git_rev:        "0afd9a6d808944e65a7be393e31868b85345735f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_twig",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "typescript",
        extensions:     ["ts", "mts", "cts"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-typescript",
        git_rev:        "75b3874edb2dc714fb1fd77a32013d0f8699989f",
        git_branch:     nil,
        ffi_func:       "tree_sitter_typescript",
        c_symbol:       nil,
        directory:      "typescript",
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "typespec",
        extensions:     ["tsp"],
        git_url:        "https://github.com/happenslol/tree-sitter-typespec",
        git_rev:        "395bef1e1eb4dd18365401642beb534e8a244056",
        git_branch:     nil,
        ffi_func:       "tree_sitter_typespec",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "typoscript",
        extensions:     ["typoscript", "tsconfig"],
        git_url:        "https://github.com/Teddytrombone/tree-sitter-typoscript",
        git_rev:        "b5d0162b328ec52cf300054a8a23d47f84f55cb4",
        git_branch:     nil,
        ffi_func:       "tree_sitter_typoscript",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "typst",
        extensions:     ["typst"],
        git_url:        "https://github.com/uben0/tree-sitter-typst",
        git_rev:        "46cf4ded12ee974a70bf8457263b67ad7ee0379d",
        git_branch:     "master",
        ffi_func:       "tree_sitter_typst",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "udev",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-udev",
        git_rev:        "2fcb563a4d56a6b8e8c129252325fc6335e4acbf",
        git_branch:     nil,
        ffi_func:       "tree_sitter_udev",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "ungrammar",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-ungrammar",
        git_rev:        "debd26fed283d80456ebafa33a06957b0c52e451",
        git_branch:     nil,
        ffi_func:       "tree_sitter_ungrammar",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "uxntal",
        extensions:     ["tal"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-uxntal",
        git_rev:        "ad9b638b914095320de85d59c49ab271603af048",
        git_branch:     nil,
        ffi_func:       "tree_sitter_uxntal",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "v",
        extensions:     ["v"],
        git_url:        "https://github.com/nedpals/tree-sitter-v",
        git_rev:        "fee18d64a51127b32a221a56509f77c942d9923f",
        git_branch:     "master",
        ffi_func:       "tree_sitter_v",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "vb",
        extensions:     ["vb"],
        git_url:        "https://github.com/CodeAnt-AI/tree-sitter-vb-dotnet",
        git_rev:        "cfca210ce8fdcb5245bd9cd5c47ce0a21a8488d5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_vb_dotnet",
        c_symbol:       "vb_dotnet",
        directory:      nil,
        abi_version:    nil,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "verilog",
        extensions:     ["verilog"],
        git_url:        "https://github.com/tree-sitter/tree-sitter-verilog",
        git_rev:        "227d277b6a1a5e2bf818d6206935722a7503de08",
        git_branch:     nil,
        ffi_func:       "tree_sitter_verilog",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "vhdl",
        extensions:     ["vhdl", "vhd"],
        git_url:        "https://github.com/alemuller/tree-sitter-vhdl",
        git_rev:        "a3b2d84990527c7f8f4ae219c332c00c33d2d8e5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_vhdl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "vhs",
        extensions:     ["tape"],
        git_url:        "https://github.com/charmbracelet/tree-sitter-vhs",
        git_rev:        "0c6fae9d2cfc5b217bfd1fe84a7678f5917116db",
        git_branch:     nil,
        ffi_func:       "tree_sitter_vhs",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "vim",
        extensions:     ["vim"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-vim",
        git_rev:        "3092fcd99eb87bbd0fc434aa03650ba58bd5b43b",
        git_branch:     nil,
        ffi_func:       "tree_sitter_vim",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "vimdoc",
        extensions:     ["txt"],
        git_url:        "https://github.com/neovim/tree-sitter-vimdoc",
        git_rev:        "23daa416c1ff5d15f59a1aa648f031d6e3ee15c5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_vimdoc",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "vrl",
        extensions:     ["vrl"],
        git_url:        "https://github.com/belltoy/tree-sitter-vrl",
        git_rev:        "274b3ce63f72aa8ffea18e7fc280d3062d28f0ba",
        git_branch:     nil,
        ffi_func:       "tree_sitter_vrl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "vue",
        extensions:     ["vue"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-vue",
        git_rev:        "ce8011a414fdf8091f4e4071752efc376f4afb08",
        git_branch:     nil,
        ffi_func:       "tree_sitter_vue",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "wast",
        extensions:     ["wast"],
        git_url:        "https://github.com/mkatychev/tree-sitter-wasm",
        git_rev:        "ec42b8446502783edad7f34cbfd0d9051ea672ee",
        git_branch:     nil,
        ffi_func:       "tree_sitter_wast",
        c_symbol:       nil,
        directory:      "wast",
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "wat",
        extensions:     ["wat"],
        git_url:        "https://github.com/mkatychev/tree-sitter-wasm",
        git_rev:        "ec42b8446502783edad7f34cbfd0d9051ea672ee",
        git_branch:     nil,
        ffi_func:       "tree_sitter_wat",
        c_symbol:       nil,
        directory:      "wat",
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "wgsl",
        extensions:     ["wgsl"],
        git_url:        "https://github.com/szebniok/tree-sitter-wgsl",
        git_rev:        "40259f3c77ea856841a4e0c4c807705f3e4a2b65",
        git_branch:     "master",
        ffi_func:       "tree_sitter_wgsl",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "wgsl_bevy",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-wgsl-bevy",
        git_rev:        "d9306a798ede627001a8e5752f775858c8edd7e4",
        git_branch:     nil,
        ffi_func:       "tree_sitter_wgsl_bevy",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "wit",
        extensions:     ["wit"],
        git_url:        "https://github.com/bytecodealliance/tree-sitter-wit",
        git_rev:        "ae17db1678681a8e75c1ac48107d6efb95343cb3",
        git_branch:     nil,
        ffi_func:       "tree_sitter_wit",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     false,
      },
      {
        name:           "x86asm",
        extensions:     [] of String,
        git_url:        "https://github.com/bearcove/tree-sitter-x86asm",
        git_rev:        "9d028294a5f34188cd2cfcd290a2ec0ad31107e0",
        git_branch:     nil,
        ffi_func:       "tree_sitter_x86asm",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "xcompose",
        extensions:     [] of String,
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-xcompose",
        git_rev:        "a51d6366f041dbefec4da39a7eb3168a9b1cbc0e",
        git_branch:     nil,
        ffi_func:       "tree_sitter_xcompose",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "xml",
        extensions:     ["xml", "xsl", "xslt"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-xml",
        git_rev:        "5000ae8f22d11fbe93939b05c1e37cf21117162d",
        git_branch:     nil,
        ffi_func:       "tree_sitter_xml",
        c_symbol:       nil,
        directory:      "xml",
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "yaml",
        extensions:     ["yaml", "yml"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-yaml",
        git_rev:        "a1c4812a73ec5e089de8e441fdea3a921e8d5079",
        git_branch:     "master",
        ffi_func:       "tree_sitter_yaml",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "yuck",
        extensions:     ["yuck"],
        git_url:        "https://github.com/tree-sitter-grammars/tree-sitter-yuck",
        git_rev:        "6c60112b3b3e739fb1ca4a8ea4bea2b6ffe11318",
        git_branch:     nil,
        ffi_func:       "tree_sitter_yuck",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "zig",
        extensions:     ["zig"],
        git_url:        "https://github.com/maxxnino/tree-sitter-zig",
        git_rev:        "a80a6e9be81b33b182ce6305ae4ea28e29211bd5",
        git_branch:     nil,
        ffi_func:       "tree_sitter_zig",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: true,
        has_locals:     true,
      },
      {
        name:           "ziggy",
        extensions:     ["ziggy"],
        git_url:        "https://github.com/kristoff-it/ziggy",
        git_rev:        "7b81a7f1c9e6b22aacd7060b17bb6b7142878cd8",
        git_branch:     nil,
        ffi_func:       "tree_sitter_ziggy",
        c_symbol:       nil,
        directory:      "tree-sitter-ziggy",
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "ziggy_schema",
        extensions:     [] of String,
        git_url:        "https://github.com/kristoff-it/ziggy",
        git_rev:        "7b81a7f1c9e6b22aacd7060b17bb6b7142878cd8",
        git_branch:     nil,
        ffi_func:       "tree_sitter_ziggy_schema",
        c_symbol:       nil,
        directory:      "tree-sitter-ziggy-schema",
        abi_version:    nil,
        generate:       false,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
      {
        name:           "zsh",
        extensions:     ["zsh"],
        git_url:        "https://github.com/georgeharker/tree-sitter-zsh",
        git_rev:        "7a593401efb5418ffdedbe3c0e4c61c6d240166d",
        git_branch:     nil,
        ffi_func:       "tree_sitter_zsh",
        c_symbol:       nil,
        directory:      nil,
        abi_version:    14_i64,
        generate:       true,
        nvim_like:      true,
        has_injections: false,
        has_locals:     false,
      },
    ] of NamedTuple(name: String, extensions: Array(String), git_url: String, git_rev: String, git_branch: String?, ffi_func: String, c_symbol: String?, directory: String?, abi_version: Int64?, generate: Bool, nvim_like: Bool, has_injections: Bool, has_locals: Bool)
  end
end
