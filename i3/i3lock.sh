#!/usr/bin/env sh
# pets: package=yay:i3lock-color
# pets: symlink=~/.config/i3/i3lock.sh, mode=0755

# Variables
tmpbg='/tmp/screen.png'
B='#00000000' # blank
C='#ffffff22' # clear ish
D='#032e72ff' # default
T='#27027cff' # text
W='#c60707bb' # wrong
V='#bb00bbbb' # verifying

# Take Screenshot and pixelate it
scrot "$tmpbg"
convert "$tmpbg" -scale 4% -scale 2500% "$tmpbg"

i3lock -i "$tmpbg" \
	--insidever-color=$C \
	--ringver-color=$V \
	--insidewrong-color=$C \
	--ringwrong-color=$W \
	--inside-color=$C \
	--ring-color=$D \
	--line-color=$B \
	--separator-color=$D \
	--time-color=$T \
	--time-size=64 \
	--date-size=28 \
	--date-color=$T \
	--keyhl-color=$W \
	--bshl-color=$W \
	--clock \
	--indicator \
	--time-str="%H:%M:%S" \
	--date-str="%A, %m %Y" \
	--wrong-text="Nope!" \
	--radius=180

# Clean up
rm "$tmpbg"
