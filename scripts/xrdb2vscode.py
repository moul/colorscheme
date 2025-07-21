#!/usr/bin/env python3
"""Convert xrdb format to VS Code format"""

import sys
import os
import json
from pathlib import Path

def convert_xrdb_to_vscode(directory, theme_name="moul"):
    """Convert xrdb files to VS Code terminal theme format"""
    
    # Find the specific xrdb file
    xrdb_file = Path(directory) / f"{theme_name}.xrdb"
    
    if not xrdb_file.exists():
        print("{}", file=sys.stderr)
        return
    
    colors = {}
    
    with open(xrdb_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith("#define"):
                parts = line.split(None, 2)
                if len(parts) >= 3:
                    color_name = parts[1]
                    color_value = parts[2]
                    
                    # Map to VS Code terminal colors
                    if "Foreground_Color" in color_name:
                        colors["terminal.foreground"] = color_value
                    elif "Background_Color" in color_name:
                        colors["terminal.background"] = color_value
                    elif "Cursor_Color" in color_name:
                        colors["terminalCursor.foreground"] = color_value
                    elif "Selection_Color" in color_name:
                        colors["terminal.selectionBackground"] = color_value
                    elif color_name.startswith("Ansi_"):
                        # Extract color number
                        num = int(color_name.split('_')[1])
                        if num == 0:
                            colors["terminal.ansiBlack"] = color_value
                        elif num == 1:
                            colors["terminal.ansiRed"] = color_value
                        elif num == 2:
                            colors["terminal.ansiGreen"] = color_value
                        elif num == 3:
                            colors["terminal.ansiYellow"] = color_value
                        elif num == 4:
                            colors["terminal.ansiBlue"] = color_value
                        elif num == 5:
                            colors["terminal.ansiMagenta"] = color_value
                        elif num == 6:
                            colors["terminal.ansiCyan"] = color_value
                        elif num == 7:
                            colors["terminal.ansiWhite"] = color_value
                        elif num == 8:
                            colors["terminal.ansiBrightBlack"] = color_value
                        elif num == 9:
                            colors["terminal.ansiBrightRed"] = color_value
                        elif num == 10:
                            colors["terminal.ansiBrightGreen"] = color_value
                        elif num == 11:
                            colors["terminal.ansiBrightYellow"] = color_value
                        elif num == 12:
                            colors["terminal.ansiBrightBlue"] = color_value
                        elif num == 13:
                            colors["terminal.ansiBrightMagenta"] = color_value
                        elif num == 14:
                            colors["terminal.ansiBrightCyan"] = color_value
                        elif num == 15:
                            colors["terminal.ansiBrightWhite"] = color_value
    
    # Output VS Code format
    output = {
        "workbench.colorCustomizations": colors
    }
    
    print(json.dumps(output, indent=4))

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: xrdb2vscode.py <directory> [theme_name]", file=sys.stderr)
        sys.exit(1)
    
    directory = sys.argv[1]
    theme_name = sys.argv[2] if len(sys.argv) > 2 else "moul"
    convert_xrdb_to_vscode(directory, theme_name)