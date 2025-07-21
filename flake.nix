{
  description = "ManfredTouron colorscheme - Nix-based terminal color scheme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        
        # Import color scheme definition
        colorscheme = import ./colorscheme.nix;
        
        # Import generators
        generators = import ./generators.nix { inherit lib pkgs colorscheme; };
        
        # Generate all theme files
        generateTheme = variant: {
          "ManfredTouron${lib.optionalString (variant == "light") "-Light"}.itermcolors" = 
            pkgs.writeText "ManfredTouron${lib.optionalString (variant == "light") "-Light"}.itermcolors" 
            (generators.genIterm2 variant colorscheme.colors.${variant});
            
          "ManfredTouron${lib.optionalString (variant == "light") "-Light"}.kitty" = 
            pkgs.writeText "ManfredTouron${lib.optionalString (variant == "light") "-Light"}.kitty" 
            (generators.genKitty variant colorscheme.colors.${variant});
            
          "ManfredTouron${lib.optionalString (variant == "light") "-Light"}.Xresources" = 
            pkgs.writeText "ManfredTouron${lib.optionalString (variant == "light") "-Light"}.Xresources" 
            (generators.genXresources variant colorscheme.colors.${variant});
            
          "ManfredTouron${lib.optionalString (variant == "light") "-Light"}.xrdb" = 
            pkgs.writeText "ManfredTouron${lib.optionalString (variant == "light") "-Light"}.xrdb" 
            (generators.genXrdb variant colorscheme.colors.${variant});
            
          "ManfredTouron${lib.optionalString (variant == "light") "-Light"}.hterm.js" = 
            pkgs.writeText "ManfredTouron${lib.optionalString (variant == "light") "-Light"}.hterm.js" 
            (generators.genHterm variant colorscheme.colors.${variant});
            
          "ManfredTouron${lib.optionalString (variant == "light") "-Light"}.vscode" = 
            pkgs.writeText "ManfredTouron${lib.optionalString (variant == "light") "-Light"}.vscode" 
            (generators.genVscode variant colorscheme.colors.${variant});
        };
        
        darkThemes = generateTheme "dark";
        lightThemes = generateTheme "light";
        
        dynamicTheme = {
          "ManfredTouron-Dynamic.hterm.js" = pkgs.writeText "ManfredTouron-Dynamic.hterm.js"
            (generators.genDynamicHterm colorscheme.colors.dark colorscheme.colors.light);
        };
        
        allThemes = darkThemes // lightThemes // dynamicTheme;
        
        # Build script to generate all files
        buildScript = pkgs.writeShellScriptBin "build-themes" ''
          echo "🎨 Generating ManfredTouron color schemes..."
          
          ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: file: ''
            echo "  ✓ ${name}"
            cp ${file} ${name}
          '') allThemes)}
          
          echo ""
          echo "✅ All theme files generated successfully!"
        '';
        
        # Apply theme scripts
        applyDarkTheme = pkgs.writeShellScriptBin "apply-dark-theme" ''
          # Apply ManfredTouron dark theme using OSC sequences
          printf '\033]10;${colorscheme.colors.dark.foreground}\033\\'
          printf '\033]11;${colorscheme.colors.dark.background}\033\\'
          printf '\033]12;${colorscheme.colors.dark.cursor}\033\\'
          
          # Set ANSI colors
          printf '\033]4;0;${colorscheme.colors.dark.black}\033\\'
          printf '\033]4;1;${colorscheme.colors.dark.red}\033\\'
          printf '\033]4;2;${colorscheme.colors.dark.green}\033\\'
          printf '\033]4;3;${colorscheme.colors.dark.yellow}\033\\'
          printf '\033]4;4;${colorscheme.colors.dark.blue}\033\\'
          printf '\033]4;5;${colorscheme.colors.dark.magenta}\033\\'
          printf '\033]4;6;${colorscheme.colors.dark.cyan}\033\\'
          printf '\033]4;7;${colorscheme.colors.dark.white}\033\\'
          printf '\033]4;8;${colorscheme.colors.dark.brightBlack}\033\\'
          printf '\033]4;9;${colorscheme.colors.dark.brightRed}\033\\'
          printf '\033]4;10;${colorscheme.colors.dark.brightGreen}\033\\'
          printf '\033]4;11;${colorscheme.colors.dark.brightYellow}\033\\'
          printf '\033]4;12;${colorscheme.colors.dark.brightBlue}\033\\'
          printf '\033]4;13;${colorscheme.colors.dark.brightMagenta}\033\\'
          printf '\033]4;14;${colorscheme.colors.dark.brightCyan}\033\\'
          printf '\033]4;15;${colorscheme.colors.dark.brightWhite}\033\\'
          
          echo "🎨 Applied ManfredTouron dark theme"
        '';
        
        applyLightTheme = pkgs.writeShellScriptBin "apply-light-theme" ''
          # Apply ManfredTouron light theme using OSC sequences
          printf '\033]10;${colorscheme.colors.light.foreground}\033\\'
          printf '\033]11;${colorscheme.colors.light.background}\033\\'
          printf '\033]12;${colorscheme.colors.light.cursor}\033\\'
          
          # Set ANSI colors
          printf '\033]4;0;${colorscheme.colors.light.black}\033\\'
          printf '\033]4;1;${colorscheme.colors.light.red}\033\\'
          printf '\033]4;2;${colorscheme.colors.light.green}\033\\'
          printf '\033]4;3;${colorscheme.colors.light.yellow}\033\\'
          printf '\033]4;4;${colorscheme.colors.light.blue}\033\\'
          printf '\033]4;5;${colorscheme.colors.light.magenta}\033\\'
          printf '\033]4;6;${colorscheme.colors.light.cyan}\033\\'
          printf '\033]4;7;${colorscheme.colors.light.white}\033\\'
          printf '\033]4;8;${colorscheme.colors.light.brightBlack}\033\\'
          printf '\033]4;9;${colorscheme.colors.light.brightRed}\033\\'
          printf '\033]4;10;${colorscheme.colors.light.brightGreen}\033\\'
          printf '\033]4;11;${colorscheme.colors.light.brightYellow}\033\\'
          printf '\033]4;12;${colorscheme.colors.light.brightBlue}\033\\'
          printf '\033]4;13;${colorscheme.colors.light.brightMagenta}\033\\'
          printf '\033]4;14;${colorscheme.colors.light.brightCyan}\033\\'
          printf '\033]4;15;${colorscheme.colors.light.brightWhite}\033\\'
          
          echo "🎨 Applied ManfredTouron light theme"
        '';
        
      in
      {
        # Export the color scheme for use in other Nix expressions
        lib = {
          inherit colorscheme generators;
          themes = allThemes;
        };
        
        # Packages
        packages = {
          default = buildScript;
          build-themes = buildScript;
          apply-dark-theme = applyDarkTheme;
          apply-light-theme = applyLightTheme;
        };
        
        # Apps for direct execution
        apps = {
          default = {
            type = "app";
            program = "${buildScript}/bin/build-themes";
          };
          
          build = {
            type = "app";
            program = "${buildScript}/bin/build-themes";
          };
          
          apply-dark = {
            type = "app";
            program = "${applyDarkTheme}/bin/apply-dark-theme";
          };
          
          apply-light = {
            type = "app";
            program = "${applyLightTheme}/bin/apply-light-theme";
          };
        };
        
        # Development shell
        devShells.default = pkgs.mkShell {
          name = "colorscheme-dev-shell";
          
          buildInputs = with pkgs; [
            # Core tools
            git
            gnumake
            bash
            coreutils
            
            # Python with Pillow for image generation
            (python3.withPackages (ps: with ps; [
              pillow
            ]))
            
            # Theme application scripts
            applyDarkTheme
            applyLightTheme
            buildScript
            
            # Font for better image rendering
            dejavu_fonts
          ];
          
          shellHook = ''
            echo "🎨 ManfredTouron colorscheme - Nix-based development environment"
            echo ""
            echo "Theme commands:"
            echo "  nix run        - Generate all theme files"
            echo "  nix run .#apply-dark   - Apply dark theme to terminal"
            echo "  nix run .#apply-light  - Apply light theme to terminal"
            echo ""
            echo "Development commands:"
            echo "  build-themes   - Generate all theme files"
            echo "  apply-dark-theme   - Apply dark theme"
            echo "  apply-light-theme  - Apply light theme"
            echo ""
            echo "Use the color scheme in your Nix config:"
            echo '  colorscheme = inputs.moul-colorscheme.lib.${system}.colorscheme;'
            echo ""
          '';
        };
      });
}