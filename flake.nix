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
            echo "🎨 ManfredTouron colorscheme - Nix-based development environment"
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