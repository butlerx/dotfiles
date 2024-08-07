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
	nitrogen --head="$SCREEN" --set-"$MODE" --save ~/Pictures/wallpapers/"$IMAGE"
}
