all: .tmp/tools
	cat ManfredTouron.itermcolors | ./.tmp/tools/iterm2xrdb > ManfredTouron.xrdb
	./.tmp/tools/xrdb2hterm ./ManfredTouron.xrdb > ManfredTouron.hterm
	python3 ./.tmp/tools/xrdb2Xresources.py . > ManfredTouron.Xresources
	python3 ./.tmp/tools/xrdb2kitty.py . > ManfredTouron.kitty
	python3 ./.tmp/tools/xrdb2vscode.py . > ManfredTouron.vscode

.tmp/tools:
	git clone https://github.com/mbadolato/iTerm2-Color-Schemes .tmp
