#!/usr/bin/env python3
"""Convert xrdb format to Kitty format"""

import sys
import os
from pathlib import Path

def convert_xrdb_to_kitty(directory, theme_name="ManfredTouron"):
    """Convert xrdb files to Kitty format"""
    
    # Find the specific xrdb file
    xrdb_file = Path(directory) / f"{theme_name}.xrdb"
    
    if not xrdb_file.exists():
        print(f"# {xrdb_file} not found", file=sys.stderr)
        return
    
    with open(xrdb_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith("#define"):
                parts = line.split(None, 2)
                if len(parts) >= 3:
                    color_name = parts[1]
                    color_value = parts[2]
                    
                    # Convert to Kitty format
                    if "Foreground_Color" in color_name:
                        print(f"foreground {color_value}")
                    elif "Background_Color" in color_name:
                        print(f"background {color_value}")
                    elif "Cursor_Color" in color_name:
                        print(f"cursor {color_value}")
                    elif "Selection_Color" in color_name:
                        print(f"selection_background {color_value}")
                    elif "Selected_Text_Color" in color_name:
                        print(f"selection_foreground {color_value}")
                    elif color_name.startswith("Ansi_"):
                        # Extract color number
                        num = color_name.split('_')[1]
                        print(f"color{num} {color_value}")

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: xrdb2kitty.py <directory> [theme_name]", file=sys.stderr)
        sys.exit(1)
    
    directory = sys.argv[1]
    theme_name = sys.argv[2] if len(sys.argv) > 2 else "ManfredTouron"
    convert_xrdb_to_kitty(directory, theme_name)