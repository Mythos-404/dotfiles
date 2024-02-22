#!/usr/bin/env bash

USER_SCRIPTS=$HOME/.config/hypr/scripts

# Define file_exists function
file_exists() {
	if [ -e "$1" ]; then
		return 0 # File exists
	else
		return 1 # File does not exist
	fi
}

# Kill already running processes
_ps=(rofi swaync)
for _prs in "${_ps[@]}"; do
	if pidof "${_prs}" >/dev/null; then
		pkill "${_prs}"
	fi
done

# relaunch swaync
sleep 0.5
swaync >/dev/null 2>&1 &

# Relaunching rainbow borders if the script exists
sleep 1
if file_exists "${USER_SCRIPTS}/rainbow_borders.sh"; then
	"${USER_SCRIPTS}"/rainbow_borders.sh &
fi

exit 0
