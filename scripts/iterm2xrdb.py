#!/usr/bin/env python3
"""Convert iTerm2 color scheme to Xresources format"""

import sys
import plistlib
from pathlib import Path

def rgb_to_hex(r, g, b):
    """Convert RGB values (0-1) to hex color"""
    return "#{:02x}{:02x}{:02x}".format(
        int(r * 255),
        int(g * 255),
        int(b * 255)
    )

def convert_iterm_to_xrdb(iterm_file):
    """Convert iTerm2 colorscheme to xrdb format"""
    
    # Parse plist file
    with open(iterm_file, 'rb') as f:
        plist = plistlib.load(f)
    
    # Define color mappings
    color_map = {
        'Ansi 0 Color': 'Ansi_0_Color',
        'Ansi 1 Color': 'Ansi_1_Color',
        'Ansi 2 Color': 'Ansi_2_Color',
        'Ansi 3 Color': 'Ansi_3_Color',
        'Ansi 4 Color': 'Ansi_4_Color',
        'Ansi 5 Color': 'Ansi_5_Color',
        'Ansi 6 Color': 'Ansi_6_Color',
        'Ansi 7 Color': 'Ansi_7_Color',
        'Ansi 8 Color': 'Ansi_8_Color',
        'Ansi 9 Color': 'Ansi_9_Color',
        'Ansi 10 Color': 'Ansi_10_Color',
        'Ansi 11 Color': 'Ansi_11_Color',
        'Ansi 12 Color': 'Ansi_12_Color',
        'Ansi 13 Color': 'Ansi_13_Color',
        'Ansi 14 Color': 'Ansi_14_Color',
        'Ansi 15 Color': 'Ansi_15_Color',
        'Background Color': 'Background_Color',
        'Foreground Color': 'Foreground_Color',
        'Cursor Color': 'Cursor_Color',
        'Cursor Text Color': 'Cursor_Text_Color',
        'Bold Color': 'Bold_Color',
        'Selection Color': 'Selection_Color',
        'Selected Text Color': 'Selected_Text_Color',
    }
    
    # Output xrdb format
    for iterm_key, xrdb_key in color_map.items():
        if iterm_key in plist:
            color_dict = plist[iterm_key]
            if 'Red Component' in color_dict:
                hex_color = rgb_to_hex(
                    color_dict['Red Component'],
                    color_dict['Green Component'],
                    color_dict['Blue Component']
                )
                print(f"#define {xrdb_key} {hex_color}")

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: iterm2xrdb.py <iTerm colorscheme file>", file=sys.stderr)
        sys.exit(1)
    
    convert_iterm_to_xrdb(sys.argv[1])