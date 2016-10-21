#!/bin/bash

tmpbg='/tmp/screen.png'

scrot "$tmpbg"

convert "$tmpbg" -scale 4% -scale 2500% "$tmpbg"
composite -gravity center "$tmpbg" "$tmpbg"

#enable i3lock with colours & modified image
i3lock -i "$tmpbg" -c '#000000' -o '#191d0f' -w '#932121' -l '#4e6fe4' -e

#clean up
rm "$tmpbg"
