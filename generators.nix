# Format generators for various terminal emulators
{ lib, pkgs, colorscheme }:

let
  inherit (colorscheme) colors hexToRgb rgbToFloat;
  
  # Generate iTerm2 color scheme
  genIterm2 = variant: colors: let
    colorToIterm = name: hex: let
      rgb = rgbToFloat (hexToRgb hex);
    in ''
      <key>${name}</key>
      <dict>
        <key>Alpha Component</key>
        <real>1</real>
        <key>Blue Component</key>
        <real>${toString rgb.b}</real>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Green Component</key>
        <real>${toString rgb.g}</real>
        <key>Red Component</key>
        <real>${toString rgb.r}</real>
      </dict>
    '';
  in ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      ${colorToIterm "Background Color" colors.background}
      ${colorToIterm "Foreground Color" colors.foreground}
      ${colorToIterm "Cursor Color" colors.cursor}
      ${colorToIterm "Selection Color" colors.selection}
      ${colorToIterm "Selected Text Color" colors.selectedText}
      ${colorToIterm "Cursor Text Color" colors.cursorText}
      ${colorToIterm "Bold Color" colors.bold}
      ${colorToIterm "Ansi 0 Color" colors.black}
      ${colorToIterm "Ansi 1 Color" colors.red}
      ${colorToIterm "Ansi 2 Color" colors.green}
      ${colorToIterm "Ansi 3 Color" colors.yellow}
      ${colorToIterm "Ansi 4 Color" colors.blue}
      ${colorToIterm "Ansi 5 Color" colors.magenta}
      ${colorToIterm "Ansi 6 Color" colors.cyan}
      ${colorToIterm "Ansi 7 Color" colors.white}
      ${colorToIterm "Ansi 8 Color" colors.brightBlack}
      ${colorToIterm "Ansi 9 Color" colors.brightRed}
      ${colorToIterm "Ansi 10 Color" colors.brightGreen}
      ${colorToIterm "Ansi 11 Color" colors.brightYellow}
      ${colorToIterm "Ansi 12 Color" colors.brightBlue}
      ${colorToIterm "Ansi 13 Color" colors.brightMagenta}
      ${colorToIterm "Ansi 14 Color" colors.brightCyan}
      ${colorToIterm "Ansi 15 Color" colors.brightWhite}
    </dict>
    </plist>
  '';
  
  # Generate Kitty config
  genKitty = variant: colors: ''
    # moul ${variant} theme for Kitty
    
    # Basic colors
    foreground ${colors.foreground}
    background ${colors.background}
    selection_foreground ${colors.background}
    selection_background ${colors.selection}
    
    # Cursor colors
    cursor ${colors.cursor}
    cursor_text_color ${colors.background}
    
    # Black
    color0 ${colors.black}
    color8 ${colors.brightBlack}
    
    # Red
    color1 ${colors.red}
    color9 ${colors.brightRed}
    
    # Green
    color2 ${colors.green}
    color10 ${colors.brightGreen}
    
    # Yellow
    color3 ${colors.yellow}
    color11 ${colors.brightYellow}
    
    # Blue
    color4 ${colors.blue}
    color12 ${colors.brightBlue}
    
    # Magenta
    color5 ${colors.magenta}
    color13 ${colors.brightMagenta}
    
    # Cyan
    color6 ${colors.cyan}
    color14 ${colors.brightCyan}
    
    # White
    color7 ${colors.white}
    color15 ${colors.brightWhite}
  '';
  
  # Generate Xresources
  genXresources = variant: colors: ''
    ! moul ${variant} theme
    
    ! Basic colors
    *.foreground: ${colors.foreground}
    *.background: ${colors.background}
    *.cursorColor: ${colors.cursor}
    
    ! Black
    *.color0: ${colors.black}
    *.color8: ${colors.brightBlack}
    
    ! Red
    *.color1: ${colors.red}
    *.color9: ${colors.brightRed}
    
    ! Green
    *.color2: ${colors.green}
    *.color10: ${colors.brightGreen}
    
    ! Yellow
    *.color3: ${colors.yellow}
    *.color11: ${colors.brightYellow}
    
    ! Blue
    *.color4: ${colors.blue}
    *.color12: ${colors.brightBlue}
    
    ! Magenta
    *.color5: ${colors.magenta}
    *.color13: ${colors.brightMagenta}
    
    ! Cyan
    *.color6: ${colors.cyan}
    *.color14: ${colors.brightCyan}
    
    ! White
    *.color7: ${colors.white}
    *.color15: ${colors.brightWhite}
  '';
  
  # Generate XRDB format
  genXrdb = variant: colors: ''
    ! moul ${variant} theme
    #define Ansi_0_Color ${colors.black}
    #define Ansi_1_Color ${colors.red}
    #define Ansi_2_Color ${colors.green}
    #define Ansi_3_Color ${colors.yellow}
    #define Ansi_4_Color ${colors.blue}
    #define Ansi_5_Color ${colors.magenta}
    #define Ansi_6_Color ${colors.cyan}
    #define Ansi_7_Color ${colors.white}
    #define Ansi_8_Color ${colors.brightBlack}
    #define Ansi_9_Color ${colors.brightRed}
    #define Ansi_10_Color ${colors.brightGreen}
    #define Ansi_11_Color ${colors.brightYellow}
    #define Ansi_12_Color ${colors.brightBlue}
    #define Ansi_13_Color ${colors.brightMagenta}
    #define Ansi_14_Color ${colors.brightCyan}
    #define Ansi_15_Color ${colors.brightWhite}
    #define Background_Color ${colors.background}
    #define Foreground_Color ${colors.foreground}
    #define Cursor_Color ${colors.cursor}
    #define Selection_Color ${colors.selection}
  '';
  
  # Generate hterm JavaScript
  genHterm = variant: colors: ''
    // moul ${variant} theme for hterm
    const terminalProfile = {
      cursor: '${colors.cursor}',
      foreground: '${colors.foreground}',
      background: '${colors.background}',
      colors: [
        '${colors.black}',
        '${colors.red}',
        '${colors.green}',
        '${colors.yellow}',
        '${colors.blue}',
        '${colors.magenta}',
        '${colors.cyan}',
        '${colors.white}',
        '${colors.brightBlack}',
        '${colors.brightRed}',
        '${colors.brightGreen}',
        '${colors.brightYellow}',
        '${colors.brightBlue}',
        '${colors.brightMagenta}',
        '${colors.brightCyan}',
        '${colors.brightWhite}'
      ]
    };
    
    for (const [key, value] of Object.entries(terminalProfile)) {
      term_.prefs_.set(key, value);
    }
  '';
  
  # Generate VS Code theme
  genVscode = variant: colors: let
    theme = if variant == "dark" then "vs-dark" else "vs";
  in ''
    {
      "name": "moul ${variant}",
      "type": "${if variant == "dark" then "dark" else "light"}",
      "colors": {
        "terminal.background": "${colors.background}",
        "terminal.foreground": "${colors.foreground}",
        "terminal.ansiBlack": "${colors.black}",
        "terminal.ansiRed": "${colors.red}",
        "terminal.ansiGreen": "${colors.green}",
        "terminal.ansiYellow": "${colors.yellow}",
        "terminal.ansiBlue": "${colors.blue}",
        "terminal.ansiMagenta": "${colors.magenta}",
        "terminal.ansiCyan": "${colors.cyan}",
        "terminal.ansiWhite": "${colors.white}",
        "terminal.ansiBrightBlack": "${colors.brightBlack}",
        "terminal.ansiBrightRed": "${colors.brightRed}",
        "terminal.ansiBrightGreen": "${colors.brightGreen}",
        "terminal.ansiBrightYellow": "${colors.brightYellow}",
        "terminal.ansiBrightBlue": "${colors.brightBlue}",
        "terminal.ansiBrightMagenta": "${colors.brightMagenta}",
        "terminal.ansiBrightCyan": "${colors.brightCyan}",
        "terminal.ansiBrightWhite": "${colors.brightWhite}",
        "terminalCursor.background": "${colors.background}",
        "terminalCursor.foreground": "${colors.cursor}"
      }
    }
  '';
  
  # Generate dynamic hterm theme
  genDynamicHterm = darkColors: lightColors: ''
    // moul Dynamic theme for hterm
    // Automatically switches between light and dark based on system preference
    
    const darkScheme = {
      cursor: '${darkColors.cursor}',
      foreground: '${darkColors.foreground}',
      background: '${darkColors.background}',
      colors: [
        '${darkColors.black}', '${darkColors.red}', '${darkColors.green}', '${darkColors.yellow}',
        '${darkColors.blue}', '${darkColors.magenta}', '${darkColors.cyan}', '${darkColors.white}',
        '${darkColors.brightBlack}', '${darkColors.brightRed}', '${darkColors.brightGreen}', '${darkColors.brightYellow}',
        '${darkColors.brightBlue}', '${darkColors.brightMagenta}', '${darkColors.brightCyan}', '${darkColors.brightWhite}'
      ]
    };
    
    const lightScheme = {
      cursor: '${lightColors.cursor}',
      foreground: '${lightColors.foreground}',
      background: '${lightColors.background}',
      colors: [
        '${lightColors.black}', '${lightColors.red}', '${lightColors.green}', '${lightColors.yellow}',
        '${lightColors.blue}', '${lightColors.magenta}', '${lightColors.cyan}', '${lightColors.white}',
        '${lightColors.brightBlack}', '${lightColors.brightRed}', '${lightColors.brightGreen}', '${lightColors.brightYellow}',
        '${lightColors.brightBlue}', '${lightColors.brightMagenta}', '${lightColors.brightCyan}', '${lightColors.brightWhite}'
      ]
    };
    
    function applyScheme(scheme) {
      for (const [key, value] of Object.entries(scheme)) {
        term_.prefs_.set(key, value);
      }
    }
    
    function updateTheme() {
      const isDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
      applyScheme(isDark ? darkScheme : lightScheme);
    }
    
    // Initial theme
    updateTheme();
    
    // Listen for changes
    if (window.matchMedia) {
      window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', updateTheme);
    }
  '';
  
in {
  inherit genIterm2 genKitty genXresources genXrdb genHterm genVscode genDynamicHterm;
}