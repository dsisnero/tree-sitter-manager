#!/usr/bin/env crystal
# Convert syntastica Rust theme file to Crystal theme file.
# Usage: crystal run scripts/convert_theme.cr -- vendor/syntastica/syntastica-themes/src/tokyo.rs

input = ARGV[0]?
abort "Usage: crystal run scripts/convert_theme.cr -- <theme.rs>" unless input

module_name = File.basename(input, ".rs")

def rgb_to_hex(r : Int32, g : Int32, b : Int32) : String
  sprintf("#%02x%02x%02x", r, g, b)
end

lines = File.read_lines(input)
output = String.build do |io|
  current_fn = ""
  entries = [] of {String, String, String?, String}

  lines.each do |line|
    # Detect function start: pub fn storm() -> ResolvedTheme {
    if (md = line.match(/pub fn (\w+)\(\) -> ResolvedTheme/))
      current_fn = md[1]
    elsif line =~ /^\}\]\)/
      # End of function body
      if current_fn != "" && !entries.empty?
        crystal_fn = "#{module_name}_#{current_fn}"
        io << "    def #{crystal_fn} : ResolvedTheme\n"
        io << "      t = Theme.new\n"
        entries.each do |(key, fg, bg, flags)|
          if bg || flags != ""
            parts = ["color: #{fg.inspect}"]
            parts << "bg: #{bg.inspect}" if bg
            parts << flags if flags != ""
            io << "      t.set_extended(#{key.inspect}, #{parts.join(", ")})\n"
          else
            io << "      t.set(#{key.inspect}, #{fg.inspect})\n"
          end
        end
        io << "      t.resolve\n"
        io << "    end\n"
        io << "\n"
      end
      current_fn = ""
      entries.clear
    elsif current_fn != "" && (md = line.match(/"(.+?)".*Style::new\(/))
      key = md[1]
      # Extract all Color::new(r, g, b) occurrences
      colors = line.scan(/Color::new\((\d+),\s*(\d+),\s*(\d+)\)/)
      next if colors.empty?

      fg_c = colors[0]
      fg_hex = rgb_to_hex(fg_c[1].to_i, fg_c[2].to_i, fg_c[3].to_i)

      bg_hex = nil
      if colors.size > 1
        bg_c = colors[1]
        bg_hex = rgb_to_hex(bg_c[1].to_i, bg_c[2].to_i, bg_c[3].to_i)
      end

      # Parse flags: the 4 last true/false in the line
      bools = line.scan(/(true|false)/).map(&.[1])
      flags_parts = [] of String
      if bools.size >= 4
        flags_parts << "underline: true" if bools[-4] == "true"
        flags_parts << "strikethrough: true" if bools[-3] == "true"
        flags_parts << "italic: true" if bools[-2] == "true"
        flags_parts << "bold: true" if bools[-1] == "true"
      end
      flags_str = flags_parts.join(", ")

      entries << {key, fg_hex, bg_hex, flags_str}
    end
  end
end

puts output
