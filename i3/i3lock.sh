#!/bin/bash

tmpbg='/tmp/screen.png'

scrot "$tmpbg"

convert "$tmpbg" -scale 10% -scale 1000% "$tmpbg"
composite -gravity center "$tmpbg" "$tmpbg"

#enable i3lock with colours & modified image
i3lock --textcolor=ffffff00 --insidecolor=ffffff00 --ringcolor=ffffff00 --linecolor=ffffff00 --keyhlcolor=FF000080 --ringvercolor=0000FF00 --insidevercolor=00000000 --ringwrongcolor=00000055 --insidewrongcolor=FF00001c  -i "$tmpbg"

i3lock  -i "$tmpbg"
#clean up
rm "$tmpbg"
