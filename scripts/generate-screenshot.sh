#!/bin/bash
# Generate screenshot of color scheme using various methods

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Method 1: Using terminal-screenshot tools
generate_with_termshot() {
    if command -v termshot &> /dev/null; then
        echo "Generating screenshot with termshot..."
        # Apply the color scheme first
        "$SCRIPT_DIR/apply-theme.sh" "${1:-dark}"
        
        # Display color test pattern
        "$SCRIPT_DIR/../contrib/256-color-table.sh"
        
        # Take screenshot
        termshot -o "$ROOT_DIR/assets/term.png"
    else
        echo "termshot not found. Install with: npm install -g termshot"
        return 1
    fi
}

# Method 2: Using ANSI color blocks
generate_color_blocks() {
    theme="${1:-dark}"
    output_file="$ROOT_DIR/assets/color-blocks-$theme.txt"
    
    echo "Generating color blocks for $theme theme..."
    
    cat > "$output_file" << 'EOF'
moul Color Scheme
==========================

Normal Colors:
EOF
    
    # Normal colors (0-7)
    for i in {0..7}; do
        printf "\033[48;5;${i}m  %d  \033[0m " "$i" >> "$output_file"
    done
    echo >> "$output_file"
    
    echo -e "\nBright Colors:" >> "$output_file"
    
    # Bright colors (8-15)
    for i in {8..15}; do
        printf "\033[48;5;${i}m %02d  \033[0m " "$i" >> "$output_file"
    done
    echo >> "$output_file"
    
    echo -e "\nColor Test:" >> "$output_file"
    for attr in 0 1 4 7; do
        echo -n "ESC[${attr}m: \033[${attr}m" >> "$output_file"
        for color in {30..37}; do
            echo -n " \033[${attr};${color}mText\033[0m" >> "$output_file"
        done
        echo "\033[0m" >> "$output_file"
    done
}

# Method 3: Using asciinema + svg-term
generate_with_asciinema() {
    if command -v asciinema &> /dev/null && command -v svg-term &> /dev/null; then
        echo "Generating screenshot with asciinema + svg-term..."
        
        # Record terminal session
        asciinema rec -c "$SCRIPT_DIR/../contrib/256-color-table.sh" /tmp/colorscheme.cast
        
        # Convert to SVG
        svg-term --out "$ROOT_DIR/assets/term.svg" --window --no-cursor --at 5000 /tmp/colorscheme.cast
        
        # Optionally convert SVG to PNG with imagemagick
        if command -v convert &> /dev/null; then
            convert -density 144 "$ROOT_DIR/assets/term.svg" "$ROOT_DIR/assets/term.png"
        fi
        
        rm -f /tmp/colorscheme.cast
    else
        echo "asciinema or svg-term not found"
        echo "Install with: pip install asciinema && npm install -g svg-term-cli"
        return 1
    fi
}

# Method 4: Using terminal HTML renderer
generate_html_preview() {
    theme="${1:-dark}"
    output_file="$ROOT_DIR/assets/preview-$theme.html"
    
    echo "Generating HTML preview for $theme theme..."
    
    # Load colors from xrdb file
    if [ "$theme" == "light" ]; then
        xrdb_file="$ROOT_DIR/moul-light.xrdb"
    else
        xrdb_file="$ROOT_DIR/moul.xrdb"
    fi
    
    # Extract colors
    declare -A colors
    while IFS= read -r line; do
        if [[ $line =~ ^#define[[:space:]]+([A-Za-z_0-9]+)[[:space:]]+(#[0-9a-fA-F]{6}) ]]; then
            colors["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
        fi
    done < "$xrdb_file"
    
    cat > "$output_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>moul $theme Theme</title>
    <style>
        body {
            background: ${colors[Background_Color]};
            color: ${colors[Foreground_Color]};
            font-family: 'Fira Code', 'Monaco', monospace;
            padding: 20px;
        }
        .color-grid {
            display: grid;
            grid-template-columns: repeat(8, 1fr);
            gap: 10px;
            margin: 20px 0;
        }
        .color-box {
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid ${colors[Foreground_Color]};
        }
        pre {
            background: rgba(128,128,128,0.1);
            padding: 20px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <h1>moul $theme Theme</h1>
    <div class="color-grid">
EOF
    
    # Generate color boxes
    for i in {0..15}; do
        color_key="Ansi_${i}_Color"
        if [ "${colors[$color_key]}" ]; then
            echo "        <div class='color-box' style='background: ${colors[$color_key]}'>${i}</div>" >> "$output_file"
        fi
    done
    
    cat >> "$output_file" << 'EOF'
    </div>
    <pre>
# Sample code
def hello_world():
    """A simple function"""
    colors = ["red", "green", "blue"]
    for color in colors:
        print(f"Hello, {color} world!")
    return True

if __name__ == "__main__":
    hello_world()
    </pre>
</body>
</html>
EOF
    
    echo "HTML preview generated at $output_file"
}

# Main function
main() {
    method="${1:-auto}"
    theme="${2:-dark}"
    
    case "$method" in
        termshot)
            generate_with_termshot "$theme"
            ;;
        blocks)
            generate_color_blocks "$theme"
            ;;
        asciinema)
            generate_with_asciinema
            ;;
        html)
            generate_html_preview "$theme"
            ;;
        auto)
            # Try methods in order of preference
            generate_with_asciinema || \
            generate_with_termshot "$theme" || \
            generate_html_preview "$theme" || \
            generate_color_blocks "$theme"
            ;;
        *)
            echo "Usage: $0 [method] [theme]"
            echo "Methods: termshot, blocks, asciinema, html, auto (default)"
            echo "Themes: dark (default), light"
            exit 1
            ;;
    esac
}

main "$@"