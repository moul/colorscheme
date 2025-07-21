# Generate all theme files using Nix
all: build

# Generate all theme files from Nix
build:
	@echo "Generating theme files from Nix..."
	@nix run . --extra-experimental-features 'nix-command flakes'


# Legacy targets for compatibility
dark: build
	@echo "✓ Dark theme files generated"

light: build
	@echo "✓ Light theme files generated"

dynamic: build
	@echo "✓ Dynamic theme file generated"

clean:
	rm -rf .tmp/ result result-* backup/
	rm -f ManfredTouron*.xrdb ManfredTouron*.hterm.js ManfredTouron*.Xresources ManfredTouron*.kitty ManfredTouron*.vscode ManfredTouron*.itermcolors

screenshot: build
	@echo "Generating screenshots..."
	@nix develop --extra-experimental-features 'nix-command flakes' -c bash -c '\
		mkdir -p assets && \
		python3 scripts/generate-preview.py'

# Development shell
dev:
	@nix develop --extra-experimental-features 'nix-command flakes'

# Help
help:
	@echo "ManfredTouron Color Scheme - Nix-based"
	@echo ""
	@echo "Commands:"
	@echo "  make build       - Generate all theme files"
	@echo "  make screenshot  - Generate preview screenshots"
	@echo "  make clean       - Clean generated files"
	@echo "  make dev         - Enter development shell"
	@echo "  make help        - Show this help"

.PHONY: all build dark light dynamic clean screenshot dev help
