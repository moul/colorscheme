.PHONY: help build clean screenshot dev

help:
	@echo "Commands:"
	@echo "  make build       - Generate all theme files"
	@echo "  make screenshot  - Generate preview screenshots"
	@echo "  make clean       - Clean generated files"
	@echo "  make dev         - Enter development shell"

build:
	@nix run . --extra-experimental-features 'nix-command flakes'

clean:
	rm -rf .tmp/ result result-* backup/
	rm -f moul*.xrdb moul*.hterm.js moul*.Xresources moul*.kitty moul*.vscode moul*.itermcolors

screenshot: build
	@nix develop --extra-experimental-features 'nix-command flakes' -c bash -c '\
		mkdir -p assets && \
		python3 scripts/generate-preview.py'

dev:
	@nix develop --extra-experimental-features 'nix-command flakes'
