#!/usr/bin/env bash

iDIR="$HOME/.config/swaync/icons"
# notification_timeout=1000

# Get brightness
get_backlight() {
	ddcutil getvcp 10 | rg -No 'value =    (.*),' -r '$1' | tr -d '[:space:]'
}

# Get icons
get_icon() {
	if [ "$current" -le "20" ]; then
		icon="$iDIR/brightness-20.png"
	elif [ "$current" -le "40" ]; then
		icon="$iDIR/brightness-40.png"
	elif [ "$current" -le "60" ]; then
		icon="$iDIR/brightness-60.png"
	elif [ "$current" -le "80" ]; then
		icon="$iDIR/brightness-80.png"
	else
		icon="$iDIR/brightness-100.png"
	fi
}

notify_user() {
	notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h int:value:"${current}" -u low -i "${icon}" "Brightness : ${current}%"
}

# Change brightness
change_backlight() {
	ddcutil setvcp 10 "${1}" "${2}"

	current=$(get_backlight)

	brightnessctl set "${current}"

	get_icon && notify_user
}

# Execute accordingly
case "$1" in
"--get")
	get_backlight
	;;
"--inc")
	change_backlight "+" "${2:-10}"
	;;
"--dec")
	change_backlight "-" "${2:-10}"
	;;
*)
	get_backlight
	;;
esac
