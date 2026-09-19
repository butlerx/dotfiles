#! /usr/bin/env bash

if [[ $DEBUG == 'true' ]]; then
	set -euxo pipefail
else
	set -euo pipefail
fi
IFS=$'\n\t'

move_ws() {
	{
		WORKSPACE=$1
		DIRECTION=$2
		i3-msg workspace "$WORKSPACE"
		i3-msg move workspace to output "$DIRECTION"
	} || {
		echo "Error moving workspace"
	}
}

kill_polybar() {
	pkill polybar || true
	# Wait until the processes have been shut down
	while pgrep -x polybar >/dev/null; do sleep 1; done
}

start_bar() {
	export MONITOR=$1
	BAR=$2
	polybar -c ~/.config/polybar/config.ini --reload "$BAR" </dev/null >"/var/tmp/polybar-$MONITOR.log" 2>&1 &
}

set_wallpaper() {
	SCREEN=$1
	MODE=$2
	IMAGE=$3
	# nitrogen 1.6.1 g_error()s and core dumps against newer
	# gsettings-desktop-schemas: it reads org.gnome.desktop.background
	# draw-background, a key removed upstream. It paints the root pixmap
	# before dying, so the wallpaper still lands. Crucially this file runs
	# under `set -e`, so an unguarded failure here aborts the postswitch
	# before start_bar - which is how a wallpaper bug silently killed the
	# status bars. Never let it propagate.
	nitrogen --head="$SCREEN" --set-"$MODE" --save ~/Pictures/wallpapers/"$IMAGE" ||
		echo "set_wallpaper: nitrogen exited non-zero for head $SCREEN" >&2
}
