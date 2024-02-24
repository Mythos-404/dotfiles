#!/usr/bin/env bash

USER_SCRIPTS="$HOME/.config/hypr/scripts"

WALL_DIR="$HOME/Pictures/wallpapers"

# Transition config
FPS=60
TYPE="random"
DURATION=1
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

mapfile -t PICS < <(fd '.jpg$|.jpeg$|.png$|.gif$' "${WALL_DIR}")
RANDOM_PIC="${PICS[$RANDOM % ${#PICS[@]}]}"
RANDOM_PIC_NAME="${#PICS[@]}. random"

# Rofi command
rofi_command="rofi -show -dmenu -config ~/.config/rofi/config-wallpaper.rasi"

menu() {
	for i in "${!PICS[@]}"; do
		# Displaying .gif to indicate animated images
		if echo "${PICS[$i]}" | rg -q .gif$; then
			printf '%s\n' "${PICS[$i]}"
		else
			printf '%s\x00icon\x1f%s\n' "${PICS[${i}]##*/}" "${PICS[${i}]}"
		fi
	done

	printf '%s\n' "${RANDOM_PIC_NAME}"
}

refresh_app() {
	sleep 0.5
	"${USER_SCRIPTS}"/pywal_swww.sh
	sleep 0.2
	"${USER_SCRIPTS}"/refresh_app.sh
	sleep 0.5

}

main() {
	choice=$(menu | ${rofi_command})

	# No choice case
	if [[ -z $choice ]]; then
		exit 0
	fi

	# Random choice case
	if [ "$choice" = "$RANDOM_PIC_NAME" ]; then
		swww img "${RANDOM_PIC}" $SWWW_PARAMS
		refresh_app
		exit 0
	fi

	# Find the index of the selected file
	pic_index=-1
	for i in "${!PICS[@]}"; do
		filename=$(basename "${PICS[$i]}")
		if [[ "$filename" == "$choice"* ]]; then
			pic_index=$i
			break
		fi
	done

	if [[ $pic_index -ne -1 ]]; then
		swww img "${PICS[$pic_index]}" $SWWW_PARAMS
	else
		echo "Image not found."
		exit 1
	fi
}

# Check if rofi is already running
if pidof rofi >/dev/null; then
	pkill rofi
	exit 0
fi

main

refresh_app
