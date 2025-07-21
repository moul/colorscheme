{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
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
    
    # Optional screenshot tools
    asciinema
    
    # Font for better image rendering
    dejavu_fonts
  ];
  
  shellHook = ''
    echo "🎨 moul colorscheme development environment"
    echo "Available commands:"
    echo "  make all        - Generate all theme formats"
    echo "  make screenshot - Generate previews (with PNG support)"
    echo "  make clean      - Clean generated files"
    echo ""
    echo "Dependencies loaded:"
    echo "  ✓ Python $(python3 --version | cut -d' ' -f2) with Pillow"
    echo "  ✓ Git $(git --version | cut -d' ' -f3)"
    echo "  ✓ GNU Make $(make --version | head -1 | cut -d' ' -f3)"
    
    # Verify Pillow is available
    if python3 -c "import PIL; print('  ✓ Pillow', PIL.__version__)" 2>/dev/null; then
      echo "  ✓ Image generation ready"
    else
      echo "  ✗ Pillow not available"
    fi
    
    echo ""
  '';
  
  # Set environment variables
  PYTHONPATH = "${pkgs.python3.withPackages (ps: with ps; [ pillow ])}/lib/python*/site-packages";
}