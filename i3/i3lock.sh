#!/usr/bin/env bash

# Variables
tmpbg='/tmp/screen.png'
B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#032e72ff'  # default
T='#27027cff'  # text
W='#c60707bb'  # wrong
V='#bb00bbbb'  # verifying

# Take Screenshot and pixelate it
scrot "$tmpbg"
convert "$tmpbg" -scale 4% -scale 2500% "$tmpbg"

i3lock -i "$tmpbg"    \
--insidevercolor=$C   \
--ringvercolor=$V     \
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
--insidecolor=$C      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
--textcolor=$T        \
--timecolor=$T        \
--timesize=64         \
--datesize=28         \
--datecolor=$T        \
--keyhlcolor=$W       \
--bshlcolor=$W        \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%A, %m %Y" \
--wrongtext="Nope!"   \
--radius=180          \
--textsize=56

# Clean up
rm "$tmpbg"
