#!/usr/bin/env bash
# Migration script from old format to Nix-based generation

set -e

echo "🔄 Migrating to Nix-based color scheme generation..."

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo "❌ Nix is not installed. Please install Nix first:"
    echo "   curl -L https://nixos.org/nix/install | sh"
    exit 1
fi

# Backup existing files
if ls ManfredTouron*.* 2>/dev/null | grep -v "\.nix$" | grep -q .; then
    echo "📦 Backing up existing theme files..."
    mkdir -p backup
    for file in ManfredTouron*.*; do
        if [[ ! "$file" =~ \.nix$ ]]; then
            mv "$file" backup/ 2>/dev/null || true
        fi
    done
    echo "   Backed up to ./backup/"
fi

# Generate new files from Nix
echo "🎨 Generating theme files from Nix..."
nix run . 2>/dev/null || nix run .#build

echo ""
echo "✅ Migration complete!"
echo ""
echo "📝 Next steps:"
echo "1. Test the generated files with your terminal"
echo "2. Remove the backup directory if everything works: rm -rf backup/"
echo "3. Update any scripts to use: nix run github:moul/colorscheme"
echo ""
echo "🚀 New commands:"
echo "   nix run .              # Generate all theme files"
echo "   nix run .#apply-dark   # Apply dark theme"
echo "   nix run .#apply-light  # Apply light theme"