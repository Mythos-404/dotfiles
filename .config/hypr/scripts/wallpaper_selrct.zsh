#!/usr/bin/env zsh

USER_SCRIPTS="$HOME/.config/hypr/scripts"

WALL_DIR="$HOME/Pictures/wallpapers"

# Transition config
FPS=150
TYPE="any"
DURATION=3
swwww_set_image() { swww img --transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION $1 }

IFS=$'\0'
PICS=($(fd -0 '.jpg$|.jpeg$|.png$|.gif$' "${WALL_DIR}"))
RANDOM_PIC="${PICS[$RANDOM % ${#PICS}]}"
RANDOM_PIC_NAME="${#PICS}. random"
unset IFS


# Rofi command
ROFI_COMMAND="rofi -show -dmenu -config ~/.config/rofi/config-wallpaper.rasi"

menu() {
	for i ($PICS) {
		# Displaying .gif to indicate animated images
		if (echo $i | rg -q .gif$) {
			printf '%s\n' $i
		} else {
			printf '%s\x00icon\x1f%s\n' ${i##*/} $i
		}
	}

	printf '%s\x00icon\x1f%s\n' $RANDOM_PIC_NAME $RANDOM_PIC
}

refresh_app() {
	sleep 0.5
	"${USER_SCRIPTS}"/pywal_swww.zsh
	sleep 0.2
	"${USER_SCRIPTS}"/refresh_app.zsh
	sleep 0.5

}

main() {
	choice=$(menu | rofi -show -dmenu -config ~/.config/rofi/config-wallpaper.rasi)

	# No choice case
	if [[ -z $choice ]] {
		exit 0
	}

	# Random choice case
	if [[ "$choice" == "$RANDOM_PIC_NAME" ]] {
		swwww_set_image "${RANDOM_PIC}"
		refresh_app
		exit 0
	}

	# Find the index of the selected file
	pic_index=-1
	for i ({1..${#PICS}}) {
		filename=$(basename "${PICS[$i]}")
		if [[ "$filename" == "$choice"* ]] {
			pic_index=$i
			break
		}
	}

	if [[ $pic_index -ne -1 ]] {
		swwww_set_image "${PICS[$pic_index]}"
	} else {
		echo "Image not found."
		exit 1
	}
}

# Check if rofi is already running
if (pidof rofi >/dev/null) {
	pkill rofi
	exit 0
}

main

refresh_app
