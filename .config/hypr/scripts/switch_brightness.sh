#!/usr/bin/env bash

iDIR="$HOME/.config/swaync/icons"

case "${1}" in
'drak')
	ddcutil setvcp 10 20 &
	brightnessctl set 20 &
	notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h int:value:"20%" -u low -i "$iDIR/brightness-20.png" "Brightness : 20%"
	;;
'light')
	ddcutil setvcp 10 50 &
	brightnessctl set 50 &
	notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h int:value:"50%" -u low -i "$iDIR/brightness-40.png" "Brightness : 50%"
	;;
esac
