#!/bin/bash
# Render a demo of the color scheme

# Function to show color palette
show_palette() {
    echo -e "\n\033[1mmoul Color Scheme\033[0m"
    echo -e "=========================="
    
    # Show basic 16 colors
    echo -e "\n\033[1mSystem Colors (0-15):\033[0m"
    for row in {0..1}; do
        for col in {0..7}; do
            color=$((row * 8 + col))
            printf "\033[48;5;%sm %2d \033[0m" "$color" "$color"
        done
        echo
    done
    
    # Show text samples
    echo -e "\n\033[1mText Samples:\033[0m"
    echo -e "\033[30mBlack (30)\033[0m \033[90mBright Black (90)\033[0m"
    echo -e "\033[31mRed (31)\033[0m \033[91mBright Red (91)\033[0m"
    echo -e "\033[32mGreen (32)\033[0m \033[92mBright Green (92)\033[0m"
    echo -e "\033[33mYellow (33)\033[0m \033[93mBright Yellow (93)\033[0m"
    echo -e "\033[34mBlue (34)\033[0m \033[94mBright Blue (94)\033[0m"
    echo -e "\033[35mMagenta (35)\033[0m \033[95mBright Magenta (95)\033[0m"
    echo -e "\033[36mCyan (36)\033[0m \033[96mBright Cyan (96)\033[0m"
    echo -e "\033[37mWhite (37)\033[0m \033[97mBright White (97)\033[0m"
    
    # Show styles
    echo -e "\n\033[1mText Styles:\033[0m"
    echo -e "Normal Text"
    echo -e "\033[1mBold Text\033[0m"
    echo -e "\033[3mItalic Text\033[0m"
    echo -e "\033[4mUnderlined Text\033[0m"
    echo -e "\033[1;31mBold Red\033[0m \033[1;32mBold Green\033[0m \033[1;34mBold Blue\033[0m"
    
    # Show code sample
    echo -e "\n\033[1mCode Sample:\033[0m"
    echo -e "\033[90m#!/bin/bash\033[0m"
    echo -e "\033[32m# A simple shell script\033[0m"
    echo -e "\033[34mfunction\033[0m \033[33mgreet\033[0m() {"
    echo -e "    \033[34mlocal\033[0m name=\033[31m\"\$1\"\033[0m"
    echo -e "    \033[34mecho\033[0m \033[31m\"Hello, \033[35m\$name\033[31m!\"\033[0m"
    echo -e "}"
    echo -e "\033[33mgreet\033[0m \033[31m\"World\"\033[0m"
}

# Function to capture output as image using script/ttyrec and other tools
capture_as_image() {
    if command -v ttyrec &> /dev/null && command -v ttygif &> /dev/null; then
        echo "Capturing terminal output..."
        ttyrec -e "bash -c 'source $0 && show_palette'" /tmp/colorscheme.ttyrec
        ttygif /tmp/colorscheme.ttyrec
        mv tty.gif assets/term.gif
        rm -f /tmp/colorscheme.ttyrec
    elif command -v script &> /dev/null; then
        echo "Using script command to capture output..."
        script -q -c "bash -c 'source $0 && show_palette'" /tmp/colorscheme.typescript
        echo "Output saved to /tmp/colorscheme.typescript"
        echo "Convert to image manually using tools like ansi2html or aha"
    else
        echo "No capture tools available. Showing demo only."
        show_palette
    fi
}

# Main
if [ "$1" == "capture" ]; then
    capture_as_image
else
    show_palette
fi