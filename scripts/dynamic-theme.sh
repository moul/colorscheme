#!/bin/bash
# Dynamic theme switcher for ManfredTouron color scheme
# Switches between light and dark themes based on system preferences or time

# Function to detect macOS dark mode
detect_macos_dark_mode() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q "Dark"; then
            echo "dark"
        else
            echo "light"
        fi
    else
        echo "unknown"
    fi
}

# Function to detect Linux dark mode (GNOME/KDE)
detect_linux_dark_mode() {
    # Try GNOME first
    if command -v gsettings &> /dev/null; then
        theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null)
        if [[ "$theme" == *"dark"* ]] || [[ "$theme" == *"Dark"* ]]; then
            echo "dark"
        else
            echo "light"
        fi
    # Try KDE
    elif command -v kreadconfig5 &> /dev/null; then
        theme=$(kreadconfig5 --file kdeglobals --group General --key ColorScheme 2>/dev/null)
        if [[ "$theme" == *"Dark"* ]]; then
            echo "dark"
        else
            echo "light"
        fi
    else
        echo "unknown"
    fi
}

# Function to determine theme based on time
get_time_based_theme() {
    hour=$(date +%H)
    # Dark theme from 6 PM to 6 AM
    if [ "$hour" -ge 18 ] || [ "$hour" -lt 6 ]; then
        echo "dark"
    else
        echo "light"
    fi
}

# Main detection logic
detect_theme() {
    mode="unknown"
    
    # Try OS-specific detection first
    if [[ "$OSTYPE" == "darwin"* ]]; then
        mode=$(detect_macos_dark_mode)
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        mode=$(detect_linux_dark_mode)
    fi
    
    # Fall back to time-based detection
    if [ "$mode" == "unknown" ]; then
        mode=$(get_time_based_theme)
    fi
    
    echo "$mode"
}

# Function to apply theme to different terminals
apply_theme() {
    theme=$1
    
    echo "Applying $theme theme..."
    
    # For iTerm2
    if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        if [ "$theme" == "light" ]; then
            echo -e "\033]50;SetProfile=ManfredTouron-Light\a"
        else
            echo -e "\033]50;SetProfile=ManfredTouron\a"
        fi
    fi
    
    # For other terminals, you might need to reload config files
    # or use terminal-specific APIs
    
    # Export environment variable for other tools to use
    export COLORSCHEME_MODE="$theme"
}

# Main execution
main() {
    mode=${1:-$(detect_theme)}
    
    case "$mode" in
        light|dark)
            apply_theme "$mode"
            echo "Theme set to: $mode"
            ;;
        toggle)
            current=$(detect_theme)
            if [ "$current" == "dark" ]; then
                apply_theme "light"
            else
                apply_theme "dark"
            fi
            ;;
        auto)
            detected=$(detect_theme)
            apply_theme "$detected"
            echo "Auto-detected theme: $detected"
            ;;
        *)
            echo "Usage: $0 [light|dark|toggle|auto]"
            echo "  light  - Switch to light theme"
            echo "  dark   - Switch to dark theme"
            echo "  toggle - Toggle between light and dark"
            echo "  auto   - Auto-detect based on system/time (default)"
            exit 1
            ;;
    esac
}

main "$@"