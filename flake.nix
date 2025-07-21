{
  description = "moul colorscheme - Nix-based terminal color scheme";

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
          "moul${lib.optionalString (variant == "light") "-light"}.itermcolors" = 
            pkgs.writeText "moul${lib.optionalString (variant == "light") "-light"}.itermcolors" 
            (generators.genIterm2 variant colorscheme.colors.${variant});
            
          "moul${lib.optionalString (variant == "light") "-light"}.kitty" = 
            pkgs.writeText "moul${lib.optionalString (variant == "light") "-light"}.kitty" 
            (generators.genKitty variant colorscheme.colors.${variant});
            
          "moul${lib.optionalString (variant == "light") "-light"}.Xresources" = 
            pkgs.writeText "moul${lib.optionalString (variant == "light") "-light"}.Xresources" 
            (generators.genXresources variant colorscheme.colors.${variant});
            
          "moul${lib.optionalString (variant == "light") "-light"}.xrdb" = 
            pkgs.writeText "moul${lib.optionalString (variant == "light") "-light"}.xrdb" 
            (generators.genXrdb variant colorscheme.colors.${variant});
            
          "moul${lib.optionalString (variant == "light") "-light"}.hterm.js" = 
            pkgs.writeText "moul${lib.optionalString (variant == "light") "-light"}.hterm.js" 
            (generators.genHterm variant colorscheme.colors.${variant});
            
          "moul${lib.optionalString (variant == "light") "-light"}.vscode" = 
            pkgs.writeText "moul${lib.optionalString (variant == "light") "-light"}.vscode" 
            (generators.genVscode variant colorscheme.colors.${variant});
        };
        
        darkThemes = generateTheme "dark";
        lightThemes = generateTheme "light";
        
        dynamicTheme = {
          "moul-dynamic.hterm.js" = pkgs.writeText "moul-dynamic.hterm.js"
            (generators.genDynamicHterm colorscheme.colors.dark colorscheme.colors.light);
        };
        
        allThemes = darkThemes // lightThemes // dynamicTheme;
        
        # Build script to generate all files
        buildScript = pkgs.writeShellScriptBin "build-themes" ''
          echo "🎨 Generating moul color schemes..."
          
          ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: file: ''
            echo "  ✓ ${name}"
            cp ${file} ${name}
          '') allThemes)}
          
          echo ""
          echo "✅ All theme files generated successfully!"
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
            
            # Build script
            buildScript
            
            # Font for better image rendering
            dejavu_fonts
          ];
          
          shellHook = ''
            echo "🎨 moul colorscheme - Nix-based development environment"
            echo ""
            echo "Commands:"
            echo "  nix run        - Generate all theme files"
            echo "  build-themes   - Generate all theme files (in dev shell)"
            echo ""
            echo "Use the color scheme in your Nix config:"
            echo '  colorscheme = inputs.moul-colorscheme.lib.${system}.colorscheme;'
            echo ""
          '';
        };
      });
}