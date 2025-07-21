# moul Color Scheme Definition
{
  # Color definitions
  colors = {
    dark = {
      # Basic colors
      background = "#000000";
      foreground = "#eeeeee";
      cursor = "#eeeeee";
      cursorText = "#000000";
      selection = "#000000";
      selectedText = "#eeeeee";
      bold = "#eeeeee";
      
      # ANSI colors (0-15)
      black = "#222222";
      red = "#ff0000";
      green = "#51ff0f";
      yellow = "#e7a800";
      blue = "#3950d7";
      magenta = "#d336b1";
      cyan = "#66b2ff";
      white = "#cecece";
      
      brightBlack = "#4e4e4e";
      brightRed = "#ff008b";
      brightGreen = "#62c750";
      brightYellow = "#f4ff00";
      brightBlue = "#70a5ed";
      brightMagenta = "#b867e6";
      brightCyan = "#00d4fc";
      brightWhite = "#ffffff";
    };
    
    light = {
      # Basic colors
      background = "#f9f9f9";
      foreground = "#191919";
      cursor = "#191919";
      cursorText = "#f9f9f9";
      selection = "#d8d8d8";
      selectedText = "#191919";
      bold = "#191919";
      
      # ANSI colors (0-15)
      black = "#eeeeee";
      red = "#cc0000";
      green = "#33b20c";
      yellow = "#b27f00";
      blue = "#263fb2";
      magenta = "#a5267f";
      cyan = "#4c8cd8";
      white = "#4c4c4c";
      
      brightBlack = "#b2b2b2";
      brightRed = "#e50066";
      brightGreen = "#3f9933";
      brightYellow = "#bfb200";
      brightBlue = "#4c7fcc";
      brightMagenta = "#994cb2";
      brightCyan = "#00a5cc";
      brightWhite = "#333333";
    };
  };
  
  # Convert RGB hex to decimal components
  hexToRgb = hex: let
    r = builtins.substring 1 2 hex;
    g = builtins.substring 3 2 hex;
    b = builtins.substring 5 2 hex;
    hexToDec = h: let
      chars = {
        "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4;
        "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
        "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15;
        "A" = 10; "B" = 11; "C" = 12; "D" = 13; "E" = 14; "F" = 15;
      };
      d1 = chars.${builtins.substring 0 1 h};
      d2 = chars.${builtins.substring 1 1 h};
    in d1 * 16 + d2;
  in {
    r = hexToDec r;
    g = hexToDec g;
    b = hexToDec b;
  };
  
  # Convert RGB to normalized float (0-1)
  rgbToFloat = rgb: {
    r = rgb.r / 255.0;
    g = rgb.g / 255.0;
    b = rgb.b / 255.0;
  };
}