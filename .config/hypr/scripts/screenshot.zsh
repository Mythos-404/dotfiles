#!/usr/bin/env zsh

case "$1" in
"--freezes")
	hyprpicker -r -z &
	sleep 0.2
	HYPRPICKER_PID=$!
	grim -l 0 -g "$(slurp -d)" >(sleep 0.2; kill $HYPRPICKER_PID; swappy -f -)
	;;
*)
	grim -l 0 -g "$(slurp -d)" - | swappy -f -
	;;
esac
