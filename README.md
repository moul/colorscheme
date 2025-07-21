# moul/colorscheme
A Nix-based terminal color scheme with dark and light variants

## Features

- **Nix-based** - All colors and logic defined in Nix for reproducibility
- **Dark and Light variants** - Optimized for different lighting conditions
- **Dynamic theme switching** - Automatically switch based on system preferences or time
- **Wide terminal support** - iTerm2, Kitty, VS Code, Xresources, Blink, and more
- **Single source of truth** - Generate all formats from one color definition

## Screenshots

### Theme Previews

| Dark Theme | Light Theme |
|------------|-------------|
| ![Dark Theme](./assets/preview-dark.png) | ![Light Theme](./assets/preview-light.png) |

### Color Tables

#### 16 Color Table
| Dark Theme | Light Theme |
|------------|-------------|
| ![16 Color Table Dark](./assets/color-table-16-dark.png) | ![16 Color Table Light](./assets/color-table-16-light.png) |

#### 256 Color Table  
| Dark Theme | Light Theme |
|------------|-------------|
| ![256 Color Table Dark](./assets/color-table-256-dark.png) | ![256 Color Table Light](./assets/color-table-256-light.png) |

#### 24-bit Color Test
| Dark Theme | Light Theme |
|------------|-------------|
| ![24-bit Color Test Dark](./assets/color-table-24bit-dark.png) | ![24-bit Color Test Light](./assets/color-table-24bit-light.png) |


## Supported Formats

| Format | File Extensions | Compatible Tools |
|--------|-----------------|------------------|
| **iTerm2** | `.itermcolors` | iTerm2, Terminal.app (import) |
| **Kitty** | `.kitty` | Kitty terminal, Kitty-based terminals |  
| **VS Code** | `.vscode` | Visual Studio Code, Code - OSS, VSCodium |
| **Xresources** | `.Xresources` | Xterm, URxvt, st, most X11 terminals |
| **XRDB** | `.xrdb` | Any terminal supporting X11 color database |
| **Hterm** | `.hterm.js` | Chrome OS Terminal, Blink Shell, Secure Shell |
| **Dynamic Hterm** | `-Dynamic.hterm.js` | Blink Shell with automatic theme switching |

## Usage

### Quick Start (Nix)

```bash
# Generate all theme files in current directory
nix run github:moul/colorscheme
```

### Using in Nix Configuration

```nix
{
  inputs = {
    colorscheme.url = "github:moul/colorscheme";
  };

  outputs = { self, colorscheme, ... }: {
    # Access color definitions
    myColors = colorscheme.lib.x86_64-linux.colorscheme.colors.dark;
    
    # Use generated theme files
    home.file.".config/kitty/theme.conf".source = 
      colorscheme.lib.x86_64-linux.themes."moul.kitty";
  };
}
```

### Manual Installation

First generate the theme files:

```bash
nix run github:moul/colorscheme
```

Then follow the terminal-specific instructions below.

### iTerm2 (macOS)
```bash
# Download and import
curl -O https://raw.githubusercontent.com/moul/colorscheme/main/moul.itermcolors
# Then: iTerm2 → Preferences → Profiles → Colors → Import → moul.itermcolors
```

### Kitty
```bash
# Add to ~/.config/kitty/kitty.conf
include moul.kitty
```

### VS Code
```bash
# Copy theme file to VS Code extensions
cp moul.vscode ~/.vscode/extensions/
```

### Xterm/URxvt
```bash
# Add to ~/.Xresources
cat moul.Xresources >> ~/.Xresources
xrdb ~/.Xresources
```

### Blink Shell (iOS/iPadOS)
```bash
# Copy moul-dynamic.hterm.js content to Blink appearance settings
# Supports automatic light/dark switching
```
