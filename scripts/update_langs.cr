#!/usr/bin/env crystal
# update_langs.cr — Ported from syntastica xtask/src/update_langs.rs
# Checks all languages in languages.toml for newer git revisions.
#
# Usage: crystal run scripts/update_langs.cr

require "../lib/toml/src/toml"

data = TOML.parse_file("languages.toml")
langs = data["languages"].as_a

puts "Checking #{langs.size} languages for updates...\n"

langs.each do |lang_entry|
  l = lang_entry.as_h
  name = l["name"].as_s
  git = l.dig?("parser", "git")
  next unless git && git.raw.is_a?(Hash)

  git_h = git.as_h
  url = git_h["url"]?.try(&.as_s)
  current_rev = git_h["rev"]?.try(&.as_s)
  next unless url && current_rev

  print "  #{name.ljust(20)} "

  branch = git_h["branch"]?.try(&.as_s)
  target = branch || "HEAD"
  output = `git ls-remote #{url} #{target} 2>/dev/null`
  if $?.success? && output =~ /^(\S+)/
    latest_rev = $1
    if latest_rev[0..11] != current_rev[0..11]
      puts "UPDATE: #{current_rev[0..11]} → #{latest_rev[0..11]}"
    else
      puts "(up to date)"
    end
  else
    puts "(could not check)"
  end
end
