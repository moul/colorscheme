#!/bin/bash
# Run a command with nix-shell if dependencies are missing

set -euo pipefail

# Check if Python with Pillow is available
if python3 -c "import PIL" 2>/dev/null; then
    # Dependencies available, run directly
    exec "$@"
elif command -v nix-shell >/dev/null 2>&1; then
    # Use nix-shell to provide dependencies
    echo "Running in nix-shell to provide dependencies..."
    exec nix-shell --quiet --run "$(printf '%q ' "$@")"
else
    echo "Error: Dependencies not available and Nix not installed."
    echo "Either:"
    echo "  1. Install Nix: https://nixos.org/download.html"
    echo "  2. Install dependencies manually: pip install Pillow"
    exit 1
fi