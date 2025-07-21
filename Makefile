# Check if we need nix-shell
NIX_SHELL := $(shell command -v nix-shell 2>/dev/null)
IN_NIX_SHELL := $(NIXSHELL_PATH)

all: .tmp/tools dark light dynamic

dark: .tmp/tools
	@if [ -f .tmp/xrdb/ManfredTouron.xrdb ]; then \
		cp .tmp/xrdb/ManfredTouron.xrdb ManfredTouron.xrdb; \
	else \
		echo "Converting iTerm to xrdb format..."; \
		python3 scripts/iterm2xrdb.py ManfredTouron.itermcolors > ManfredTouron.xrdb; \
	fi
	./.tmp/tools/xrdb2hterm ./ManfredTouron.xrdb | sed s/term_/t/ > ManfredTouron.hterm.js
	python3 scripts/xrdb2Xresources.py . ManfredTouron > ManfredTouron.Xresources
	python3 scripts/xrdb2kitty.py . ManfredTouron > ManfredTouron.kitty
	python3 scripts/xrdb2vscode.py . ManfredTouron > ManfredTouron.vscode

light: .tmp/tools
	@if [ -f .tmp/xrdb/ManfredTouron-Light.xrdb ]; then \
		cp .tmp/xrdb/ManfredTouron-Light.xrdb ManfredTouron-Light.xrdb; \
	else \
		echo "Converting light iTerm to xrdb format..."; \
		python3 scripts/iterm2xrdb.py ManfredTouron-Light.itermcolors > ManfredTouron-Light.xrdb; \
	fi
	./.tmp/tools/xrdb2hterm ./ManfredTouron-Light.xrdb | sed s/term_/t/ > ManfredTouron-Light.hterm.js
	python3 scripts/xrdb2Xresources.py . ManfredTouron-Light > ManfredTouron-Light.Xresources
	python3 scripts/xrdb2kitty.py . ManfredTouron-Light > ManfredTouron-Light.kitty
	python3 scripts/xrdb2vscode.py . ManfredTouron-Light > ManfredTouron-Light.vscode

dynamic: dark light
	scripts/run-with-nix.sh python3 scripts/generate-dynamic-hterm.py

.tmp/tools:
	git clone https://github.com/mbadolato/iTerm2-Color-Schemes .tmp

clean:
	rm -rf .tmp/
	rm -f ManfredTouron*.xrdb ManfredTouron*.hterm.js ManfredTouron*.Xresources ManfredTouron*.kitty ManfredTouron*.vscode

screenshot: all
	@echo "Generating terminal demo..."
	@mkdir -p assets
	@scripts/render-demo.sh > assets/demo.txt
	@echo "Generating ANSI previews..."
	@scripts/generate-ansi-preview.sh
	@echo "Generating HTML previews..."
	@scripts/generate-screenshot.sh html dark
	@scripts/generate-screenshot.sh html light
	@echo "Generating image previews..."
	@scripts/run-with-nix.sh python3 scripts/generate-preview.py

.PHONY: all dark light dynamic clean screenshot
