#!/bin/bash
# Generate ANSI art preview of color schemes without external dependencies

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Function to convert hex to RGB
hex_to_rgb() {
    hex="${1#\#}"
    r=$((16#${hex:0:2}))
    g=$((16#${hex:2:2}))
    b=$((16#${hex:4:2}))
    echo "$r;$g;$b"
}

# Function to generate ANSI preview from xrdb file
generate_ansi_preview() {
    local xrdb_file="$1"
    local output_file="$2"
    local theme_name="$3"
    
    # Parse colors from xrdb
    declare -A colors
    while IFS= read -r line; do
        if [[ $line =~ ^#define[[:space:]]+([A-Za-z_0-9]+)[[:space:]]+(#[0-9a-fA-F]{6}) ]]; then
            colors["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
        fi
    done < "$xrdb_file"
    
    # Generate preview
    {
        echo "╔══════════════════════════════════════════════════════════════╗"
        echo "║                    $theme_name                    ║"
        echo "╚══════════════════════════════════════════════════════════════╝"
        echo
        echo "Background: ${colors[Background_Color]:-#000000}"
        echo "Foreground: ${colors[Foreground_Color]:-#ffffff}"
        echo
        echo "┌─────────────────────────────────────────────────────────────┐"
        echo "│ ANSI Colors (0-15)                                          │"
        echo "├─────────────────────────────────────────────────────────────┤"
        
        # Display color blocks
        echo -n "│ "
        for i in {0..7}; do
            color="${colors[Ansi_${i}_Color]:-#000000}"
            rgb=$(hex_to_rgb "$color")
            echo -n -e "\033[48;2;${rgb}m  $i  \033[0m "
        done
        echo "│"
        
        echo -n "│ "
        for i in {8..15}; do
            color="${colors[Ansi_${i}_Color]:-#000000}"
            rgb=$(hex_to_rgb "$color")
            echo -n -e "\033[48;2;${rgb}m $i  \033[0m "
        done
        echo "│"
        
        echo "└─────────────────────────────────────────────────────────────┘"
        echo
        echo "┌─────────────────────────────────────────────────────────────┐"
        echo "│ Text Samples                                                │"
        echo "├─────────────────────────────────────────────────────────────┤"
        
        # Show text in each color
        for i in {0..7}; do
            color="${colors[Ansi_${i}_Color]:-#000000}"
            rgb=$(hex_to_rgb "$color")
            echo -e "│ Color $i: \033[38;2;${rgb}m████ Sample Text ████\033[0m                       │"
        done
        
        echo "├─────────────────────────────────────────────────────────────┤"
        
        for i in {8..15}; do
            color="${colors[Ansi_${i}_Color]:-#000000}"
            rgb=$(hex_to_rgb "$color")
            echo -e "│ Color $i: \033[38;2;${rgb}m████ Sample Text ████\033[0m                      │"
        done
        
        echo "└─────────────────────────────────────────────────────────────┘"
        echo
        echo "┌─────────────────────────────────────────────────────────────┐"
        echo "│ Code Sample                                                 │"
        echo "├─────────────────────────────────────────────────────────────┤"
        
        # Simulate syntax highlighting
        local comment="${colors[Ansi_8_Color]:-#888888}"
        local keyword="${colors[Ansi_4_Color]:-#0000ff}"
        local string="${colors[Ansi_2_Color]:-#00ff00}"
        local function="${colors[Ansi_3_Color]:-#ffff00}"
        local variable="${colors[Ansi_5_Color]:-#ff00ff}"
        
        echo -e "│ \033[38;2;$(hex_to_rgb "$comment")m#!/usr/bin/env python3\033[0m                              │"
        echo -e "│ \033[38;2;$(hex_to_rgb "$comment")m# Example Python code\033[0m                               │"
        echo -e "│                                                             │"
        echo -e "│ \033[38;2;$(hex_to_rgb "$keyword")mdef\033[0m \033[38;2;$(hex_to_rgb "$function")mhello_world\033[0m(name):                             │"
        echo -e "│     \033[38;2;$(hex_to_rgb "$string")m\"\"\"Greet someone\"\"\"\033[0m                              │"
        echo -e "│     message = \033[38;2;$(hex_to_rgb "$string")mf\"Hello, {name}!\"\033[0m                     │"
        echo -e "│     \033[38;2;$(hex_to_rgb "$keyword")mprint\033[0m(message)                                   │"
        echo -e "│     \033[38;2;$(hex_to_rgb "$keyword")mreturn\033[0m message                                   │"
        echo -e "│                                                             │"
        echo -e "│ \033[38;2;$(hex_to_rgb "$keyword")mif\033[0m __name__ == \033[38;2;$(hex_to_rgb "$string")m\"__main__\"\033[0m:                        │"
        echo -e "│     \033[38;2;$(hex_to_rgb "$function")mhello_world\033[0m(\033[38;2;$(hex_to_rgb "$string")m\"World\"\033[0m)                           │"
        echo "└─────────────────────────────────────────────────────────────┘"
    } > "$output_file"
    
    echo "Generated $output_file"
}

# Main
main() {
    mkdir -p "$ROOT_DIR/assets"
    
    # Generate dark theme preview
    if [ -f "$ROOT_DIR/moul.xrdb" ]; then
        generate_ansi_preview \
            "$ROOT_DIR/moul.xrdb" \
            "$ROOT_DIR/assets/preview-dark.ansi" \
            "moul Dark Theme"
    fi
    
    # Generate light theme preview
    if [ -f "$ROOT_DIR/moul-light.xrdb" ]; then
        generate_ansi_preview \
            "$ROOT_DIR/moul-light.xrdb" \
            "$ROOT_DIR/assets/preview-light.ansi" \
            "moul Light Theme"
    fi
    
    echo "ANSI previews generated successfully!"
    echo "View with: cat assets/preview-*.ansi"
}

main "$@"