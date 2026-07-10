#!/usr/bin/env python3
"""Patch all Crystal theme files to include _normal background color from syntastica Rust sources."""

import re, os

THEMES_DIR = "src/tree_sitter_manager/themes"
RUST_DIR = "vendor/syntastica/syntastica-themes/src"

def extract_all_normal_bg(rust_path):
    """Extract ALL _normal background colors from syntastica Rust theme file."""
    with open(rust_path) as f:
        content = f.read()
    
    bgs = []
    for m in re.finditer(
        r'"_normal"\.into\(\), Style::new\(Color::new\(\d+,\s*\d+,\s*\d+\),\s*Some\(Color::new\((\d+),\s*(\d+),\s*(\d+)\)\)',
        content
    ):
        r, g, b = int(m.group(1)), int(m.group(2)), int(m.group(3))
        bgs.append(f"#{r:02x}{g:02x}{b:02x}")
    return bgs

def patch_crystal_theme(cr_path, bg_list):
    """Fix _normal entries in Crystal theme file. bg_list corresponds to _normal entries in order."""
    with open(cr_path) as f:
        content = f.read()
    
    changes = 0
    for bg_hex in bg_list:
        pattern = r'(t\.set\("_normal",\s*"#[0-9a-fA-F]+"\))'
        m = re.search(pattern, content)
        if not m:
            continue
        
        old_line = m.group(1)
        indent = re.match(r'^(\s*)', old_line).group(1)
        fg = re.search(r'"#[0-9a-fA-F]+"', old_line).group(0)
        new_line = f'{indent}t.set_extended("_normal", color: {fg}, bg: "{bg_hex}")'
        content = content.replace(old_line, new_line, 1)
        changes += 1
    
    if changes > 0:
        with open(cr_path, 'w') as f:
            f.write(content)
    
    return changes

def main():
    total = 0
    for fname in sorted(os.listdir(THEMES_DIR)):
        if not fname.endswith('.cr'):
            continue
        cr_path = os.path.join(THEMES_DIR, fname)
        rust_path = os.path.join(RUST_DIR, fname.replace('.cr', '.rs'))
        if not os.path.exists(rust_path):
            continue
        bgs = extract_all_normal_bg(rust_path)
        if not bgs:
            continue
        fixed = patch_crystal_theme(cr_path, bgs)
        if fixed:
            total += fixed
            print(f"{fname}: patched {fixed}/{len(bgs)} entries: {', '.join(bgs)}")
    print(f"\nTotal: {total} entries patched")

if __name__ == "__main__":
    main()
