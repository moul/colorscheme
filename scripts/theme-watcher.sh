#!/bin/bash
# Watch for system theme changes and apply color scheme accordingly

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAST_THEME=""

# Function to check current theme
check_theme() {
    "$SCRIPT_DIR/dynamic-theme.sh" auto 2>&1 | grep -oE "(light|dark)" | tail -1
}

# Watch for theme changes
watch_theme_changes() {
    echo "Starting theme watcher..."
    echo "Press Ctrl+C to stop"
    
    while true; do
        current_theme=$(check_theme)
        
        if [ "$current_theme" != "$LAST_THEME" ] && [ -n "$current_theme" ]; then
            echo "Theme changed to: $current_theme"
            "$SCRIPT_DIR/apply-theme.sh" "$current_theme"
            LAST_THEME="$current_theme"
        fi
        
        # Check every 30 seconds
        sleep 30
    done
}

# macOS specific watcher using fswatch
watch_macos_theme() {
    if ! command -v fswatch &> /dev/null; then
        echo "fswatch not found. Install with: brew install fswatch"
        echo "Falling back to polling mode..."
        watch_theme_changes
        return
    fi
    
    echo "Starting macOS theme watcher..."
    echo "Press Ctrl+C to stop"
    
    # Watch for preference changes
    fswatch -o ~/Library/Preferences/.GlobalPreferences.plist | while read num; do
        current_theme=$(check_theme)
        if [ "$current_theme" != "$LAST_THEME" ] && [ -n "$current_theme" ]; then
            echo "Theme changed to: $current_theme"
            "$SCRIPT_DIR/apply-theme.sh" "$current_theme"
            LAST_THEME="$current_theme"
        fi
    done
}

# Linux GNOME specific watcher
watch_gnome_theme() {
    if ! command -v dbus-monitor &> /dev/null; then
        echo "dbus-monitor not found. Falling back to polling mode..."
        watch_theme_changes
        return
    fi
    
    echo "Starting GNOME theme watcher..."
    echo "Press Ctrl+C to stop"
    
    dbus-monitor --session "type='signal',interface='org.freedesktop.portal.Settings',member='SettingChanged'" | \
    while read -r line; do
        if [[ "$line" == *"color-scheme"* ]]; then
            current_theme=$(check_theme)
            if [ "$current_theme" != "$LAST_THEME" ] && [ -n "$current_theme" ]; then
                echo "Theme changed to: $current_theme"
                "$SCRIPT_DIR/apply-theme.sh" "$current_theme"
                LAST_THEME="$current_theme"
            fi
        fi
    done
}

# Main execution
main() {
    # Initial theme application
    initial_theme=$(check_theme)
    if [ -n "$initial_theme" ]; then
        echo "Initial theme: $initial_theme"
        "$SCRIPT_DIR/apply-theme.sh" "$initial_theme"
        LAST_THEME="$initial_theme"
    fi
    
    # Start appropriate watcher
    if [[ "$OSTYPE" == "darwin"* ]]; then
        watch_macos_theme
    elif [[ "$OSTYPE" == "linux-gnu"* ]] && command -v gsettings &> /dev/null; then
        watch_gnome_theme
    else
        watch_theme_changes
    fi
}

# Handle cleanup
trap "echo 'Theme watcher stopped.'; exit 0" INT TERM

main "$@"