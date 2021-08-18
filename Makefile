all: .tmp/tools
	cat ManfredTouron.itermcolors | ./.tmp/tools/iterm2xrdb > ManfredTouron.xrdb
	./.tmp/tools/xrdb2hterm ./ManfredTouron.xrdb > ManfredTouron.hterm

.tmp/tools:
	git clone https://github.com/mbadolato/iTerm2-Color-Schemes .tmp
