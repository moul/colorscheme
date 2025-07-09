#!/usr/bin/env python3
"""Generate ManfredTouron-Dynamic.hterm.js from dark and light hterm files"""

import re
import os
import sys

def extract_colors(content):
    """Extract color values from hterm.js content"""
    colors = {}
    
    # Extract cursor, foreground, background using double quotes
    cursor_match = re.search(r't\.prefs_\.set\("cursor-color", "([^"]+)"\)', content)
    fg_match = re.search(r't\.prefs_\.set\("foreground-color", "([^"]+)"\)', content)
    bg_match = re.search(r't\.prefs_\.set\("background-color", "([^"]+)"\)', content)
    
    if cursor_match:
        colors['cursor'] = cursor_match.group(1)
    if fg_match:
        colors['foreground'] = fg_match.group(1)
    if bg_match:
        colors['background'] = bg_match.group(1)
    
    # Extract color palette
    palette_match = re.search(r't\.prefs_\.set\("color-palette-overrides", \[([\s\S]+?)\]\)', content)
    if palette_match:
        palette_str = palette_match.group(1)
        colors['palette'] = [c.strip().strip('"') for c in palette_str.split(',') if c.strip()]
    
    return colors

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    root_dir = os.path.dirname(script_dir)
    
    dark_file = os.path.join(root_dir, 'ManfredTouron.hterm.js')
    light_file = os.path.join(root_dir, 'ManfredTouron-Light.hterm.js')
    output_file = os.path.join(root_dir, 'ManfredTouron-Dynamic.hterm.js')
    
    try:
        with open(dark_file, 'r') as f:
            dark_content = f.read()
        with open(light_file, 'r') as f:
            light_content = f.read()
        
        dark_colors = extract_colors(dark_content)
        light_colors = extract_colors(light_content)
        
        # Generate the dynamic theme file
        dynamic_content = f"""// ManfredTouron Dynamic Theme for hterm/Blink Shell
// Automatically switches between light and dark themes based on system preferences
// Generated from ManfredTouron.hterm.js and ManfredTouron-Light.hterm.js

// Dark theme configuration
const darkScheme = {{
  cursor: '{dark_colors['cursor']}',
  foreground: '{dark_colors['foreground']}',
  background: '{dark_colors['background']}',
  colors: [{', '.join(f"'{c}'" for c in dark_colors['palette'])}]
}};

// Light theme configuration
const lightScheme = {{
  cursor: '{light_colors['cursor']}',
  foreground: '{light_colors['foreground']}',
  background: '{light_colors['background']}',
  colors: [{', '.join(f"'{c}'" for c in light_colors['palette'])}]
}};

// Function to apply theme
function applyTheme(theme) {{
  t.prefs_.set('cursor-color', theme.cursor);
  t.prefs_.set('foreground-color', theme.foreground);
  t.prefs_.set('background-color', theme.background);
  if (theme.colors) {{
    t.prefs_.set('color-palette-overrides', theme.colors);
  }}
}}

// Function to set theme based on system preference
function setPreferredScheme() {{
  const isDarkMode = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  applyTheme(isDarkMode ? darkScheme : lightScheme);
}}

// Apply initial theme
setPreferredScheme();

// Listen for theme changes
if (window.matchMedia) {{
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', setPreferredScheme);
}}

// Optional: Add manual theme toggle function
window.toggleManfredTouronTheme = function() {{
  const currentBackground = t.prefs_.get('background-color');
  if (currentBackground === darkScheme.background) {{
    applyTheme(lightScheme);
  }} else {{
    applyTheme(darkScheme);
  }}
}};
"""

        with open(output_file, 'w') as f:
            f.write(dynamic_content)
        
        print(f"Generated {output_file} successfully!")
        
    except Exception as e:
        print(f"Error generating dynamic theme: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()