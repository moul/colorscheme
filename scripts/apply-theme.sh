#!/bin/bash
# Apply moul color scheme using escape sequences
# Works with terminals that support OSC escape sequences

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_DIR="$(dirname "$SCRIPT_DIR")"

# Default to dark theme
THEME="${1:-dark}"

# Load the appropriate xrdb file
if [ "$THEME" == "light" ]; then
    XRDB_FILE="$THEME_DIR/moul-light.xrdb"
else
    XRDB_FILE="$THEME_DIR/moul.xrdb"
fi

if [ ! -f "$XRDB_FILE" ]; then
    echo "Error: Theme file $XRDB_FILE not found. Run 'make' first."
    exit 1
fi

# Parse colors from xrdb file
declare -A colors
while IFS= read -r line; do
    if [[ $line =~ ^#define[[:space:]]+([A-Za-z_0-9]+)[[:space:]]+(#[0-9a-fA-F]{6}) ]]; then
        colors["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
    fi
done < "$XRDB_FILE"

# Function to send OSC escape sequences
send_osc() {
    local sequence="$1"
    local value="$2"
    printf "\033]%s;%s\007" "$sequence" "$value"
}

# Apply colors using OSC sequences
apply_colors() {
    # Background and foreground
    [ "${colors[Background_Color]:-}" ] && send_osc "11" "${colors[Background_Color]}"
    [ "${colors[Foreground_Color]:-}" ] && send_osc "10" "${colors[Foreground_Color]}"
    
    # Cursor colors
    [ "${colors[Cursor_Color]:-}" ] && send_osc "12" "${colors[Cursor_Color]}"
    
    # ANSI colors 0-15
    for i in {0..15}; do
        color_key="Ansi_${i}_Color"
        if [ "${colors[$color_key]:-}" ]; then
            send_osc "4;$i" "${colors[$color_key]}"
        fi
    done
    
    # Selection colors (not all terminals support these)
    if [ "${colors[Selection_Color]:-}" ]; then
        send_osc "17" "${colors[Selection_Color]}"
    fi
    if [ "${colors[Selected_Text_Color]:-}" ]; then
        send_osc "19" "${colors[Selected_Text_Color]}"
    fi
}

# Apply the colors
echo "Applying $THEME theme..."
apply_colors

# For some terminals, we might need to clear and redraw
if [ "${FORCE_REDRAW:-0}" == "1" ]; then
    clear
    echo "Theme applied: $THEME"
fi

# Export for other scripts
export COLORSCHEME_MODE="$THEME"