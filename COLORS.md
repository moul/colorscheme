# Color Scheme Structure

This document describes the color definitions used in the ManfredTouron color scheme.

## Color Definition

All colors are defined in `colorscheme.nix` with the following structure:

```nix
{
  colors = {
    dark = { ... };   # Dark theme colors
    light = { ... };  # Light theme colors
  };
}
```

## Color Properties

Each theme variant contains:

### Basic Colors
- `background` - Terminal background color
- `foreground` - Default text color
- `cursor` - Cursor color
- `cursorText` - Text color under cursor
- `selection` - Selected text background
- `selectedText` - Selected text foreground
- `bold` - Bold text color

### ANSI Colors (0-15)
- `black` (color0) - Black
- `red` (color1) - Red
- `green` (color2) - Green
- `yellow` (color3) - Yellow
- `blue` (color4) - Blue
- `magenta` (color5) - Magenta
- `cyan` (color6) - Cyan
- `white` (color7) - White
- `brightBlack` (color8) - Bright black
- `brightRed` (color9) - Bright red
- `brightGreen` (color10) - Bright green
- `brightYellow` (color11) - Bright yellow
- `brightBlue` (color12) - Bright blue
- `brightMagenta` (color13) - Bright magenta
- `brightCyan` (color14) - Bright cyan
- `brightWhite` (color15) - Bright white

## Adding New Formats

To add support for a new terminal format:

1. Edit `generators.nix`
2. Add a new generator function (e.g., `genNewFormat`)
3. Update the flake.nix to include the new format in `generateTheme`

## Using Colors in Nix

```nix
let
  colorscheme = inputs.moul-colorscheme.lib.${system}.colorscheme;
  darkBg = colorscheme.colors.dark.background;
  lightFg = colorscheme.colors.light.foreground;
in {
  # Use colors in your configuration
}
```