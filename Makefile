all: .tmp/tools dark light dynamic

dark: .tmp/tools
	cat ManfredTouron.itermcolors | ./.tmp/tools/iterm2xrdb > ManfredTouron.xrdb
	./.tmp/tools/xrdb2hterm ./ManfredTouron.xrdb | sed s/term_/t/ > ManfredTouron.hterm.js
	python3 ./.tmp/tools/xrdb2Xresources.py . > ManfredTouron.Xresources
	python3 ./.tmp/tools/xrdb2kitty.py . > ManfredTouron.kitty
	python3 ./.tmp/tools/xrdb2vscode.py . > ManfredTouron.vscode

light: .tmp/tools
	cat ManfredTouron-Light.itermcolors | ./.tmp/tools/iterm2xrdb > ManfredTouron-Light.xrdb
	./.tmp/tools/xrdb2hterm ./ManfredTouron-Light.xrdb | sed s/term_/t/ > ManfredTouron-Light.hterm.js
	python3 ./.tmp/tools/xrdb2Xresources.py . | sed 's/ManfredTouron/ManfredTouron-Light/g' > ManfredTouron-Light.Xresources
	python3 ./.tmp/tools/xrdb2kitty.py . | sed 's/ManfredTouron/ManfredTouron-Light/g' > ManfredTouron-Light.kitty
	python3 ./.tmp/tools/xrdb2vscode.py . | sed 's/ManfredTouron/ManfredTouron-Light/g' > ManfredTouron-Light.vscode

dynamic: dark light
	python3 scripts/generate-dynamic-hterm.py

.tmp/tools:
	git clone https://github.com/mbadolato/iTerm2-Color-Schemes .tmp

clean:
	rm -rf .tmp/
	rm -f ManfredTouron*.xrdb ManfredTouron*.hterm.js ManfredTouron*.Xresources ManfredTouron*.kitty ManfredTouron*.vscode

.PHONY: all dark light dynamic clean
