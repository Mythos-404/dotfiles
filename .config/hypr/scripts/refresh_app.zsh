#!/usr/bin/env zsh

USER_SCRIPTS=$HOME/.config/hypr/scripts

# Define file_exists function
file_exists() {
	if [[ -e "$1" ]] {
		return 0 # File exists
	} else {
		return 1 # File does not exist
	}
}

# Kill already running processes
_ps=(rofi swaync)
for _prs ($_ps) {
	if (pidof "${_prs}" >/dev/null) {
		pkill "${_prs}"
	}
}

# relaunch swaync
sleep 0.5
swaync >/dev/null 2>&1 &

# Relaunching rainbow borders if the script exists
# sleep 1
# if (file_exists "$USER_SCRIPTS/rainbow_borders.zsh") {
# 	"$USER_SCRIPTS"/rainbow_borders.zsh &
# }

exit 0
