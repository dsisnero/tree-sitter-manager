#!/usr/bin/env crystal
# Ports syntastica Rust theme files to Crystal.
# Usage: crystal run scripts/port_themes.cr -- vendor/syntastica/syntastica-themes/src/tokyo.rs > src/tree_sitter_manager/themes/tokyo.cr

input_file = ARGV[0]?
abort "Usage: crystal run scripts/port_themes.cr -- <theme.rs>" unless input_file

content = File.read(input_file)
lines = content.lines

module_name = File.basename(input_file, ".rs")
theme_fns = [] of {String, Array({String, String})}

in_fn = false
fn_name = ""
entries = [] of {String, String}

def rgb_to_hex(r : String, g : String, b : String) : String
  sprintf("#%02x%02x%02x", r.to_i, g.to_i, b.to_i)
end

def parse_entry(line : String) : {String, String}?
  # Pattern: ("key".into(), Style::new(Color::new(r, g, b), None, underline, strikethrough, italic, bold)),
  # or:      ("key".into(), Style::new(Color::new(r, g, b), Some(Color::new(r, g, b)), ...)),
  return nil unless line.includes?("Style::new")

  key_match = line.match(/\"(.+?)\"/)
  return nil unless key_match
  key = key_match[1]

  colors = line.scan(/Color::new\((\d+),\s*(\d+),\s*(\d+)\)/)
  return nil if colors.empty?

  fg = colors[0]
  fg_hex = rgb_to_hex(fg[1], fg[2], fg[3])

  bg_hex = nil
  if colors.size > 1
    bg = colors[1]
    bg_hex = rgb_to_hex(bg[1], bg[2], bg[3])
  end

  # Parse booleans: (underline, strikethrough, italic, bold) — the last 4 args after colors
  bools = line.scan(/(true|false)/).map(&.[1])
  # We need the last 4 bools
  underline = false
  strikethrough = false
  italic = false
  bold = false
  if bools.size >= 4
    underline = bools[-4] == "true"
    strikethrough = bools[-3] == "true"
    italic = bools[-2] == "true"
    bold = bools[-1] == "true"
  end

  has_modifiers = underline || strikethrough || italic || bold || bg_hex

  if has_modifiers
    parts = ["color: #{fg_hex.inspect}"]
    parts << "bg: #{bg_hex.inspect}" if bg_hex
    parts << "underline: true" if underline
    parts << "strikethrough: true" if strikethrough
    parts << "italic: true" if italic
    parts << "bold: true" if bold
    crystal_line = "      t.set_extended(#{key.inspect}, #{parts.join(", ")})"
  else
    crystal_line = "      t.set(#{key.inspect}, #{fg_hex.inspect})"
  end

  {key, crystal_line}
end

lines.each do |line|
  if line =~ /pub fn (\w+)\(\) -> ResolvedTheme/
    fn_name = $1
    in_fn = true
    entries = [] of {String, String}
  elsif in_fn && line =~ /^\}\]\)/
    in_fn = false
    theme_fns << {fn_name, entries}
  elsif in_fn
    if entry = parse_entry(line)
      entries << entry
    end
  end
end

# Output Crystal code
puts "module TreeSitterManager"
puts "  module Themes"

theme_fns.each do |(fn_name, entries)|
  crystal_fn_name = fn_name.tr('-', '_')
  puts ""
  puts "    def #{module_name}_#{crystal_fn_name} : ResolvedTheme"
  puts "      t = Theme.new"
  entries.each do |(key, line)|
    puts line
  end
  puts "      t.resolve"
  puts "    end"
end

puts "  end"
puts "end"
