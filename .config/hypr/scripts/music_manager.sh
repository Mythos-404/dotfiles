#!/usr/bin/env bash

# Import Current Theme
RASI="$HOME/.config/rofi/config-music.rasi"

# Theme Elements
mpc_status="$(mpc status)"
if [[ $(echo "${mpc_status}" | wc -l) == 1 ]]; then
	prompt='offline'
	mesg='mpd is offline'
else
	prompt="$(mpc -f "%artist%" current)"
	mesg="$(mpc -f "%file%" current)"
fi

# Options
if [[ ${mpc_status} == *"[playing]"* ]]; then
	option_1=""
else
	option_1=""
fi
option_2=""
option_3=""
option_4=""
option_5=""
option_6=""

# Toggle Actions
active=''
urgent=''
# Repeat
if [[ ${mpc_status} == *"repeat: on"* ]]; then
	active="-a 4"
elif [[ ${mpc_status} == *"repeat: off"* ]]; then
	urgent="-u 4"
else
	option_5=" Parsing Error"
fi
# Random
if [[ ${mpc_status} == *"random: on"* ]]; then
	[ -n "$active" ] && active+=",5" || active="-a 5"
elif [[ ${mpc_status} == *"random: off"* ]]; then
	[ -n "$urgent" ] && urgent+=",5" || urgent="-u 5"
else
	option_6=" Parsing Error"
fi

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "${option_1}\n${option_2}\n${option_3}\n${option_4}\n${option_5}\n${option_6}" |
		rofi -dmenu \
			-p "${prompt}" \
			-mesg "${mesg}" \
			${active} ${urgent} \
			-markup-rows \
			-theme "${RASI}"

}

# Execute Command
iDIR="$HOME/.config/swaync/icons"
notify_song="notify-send -h string:x-canonical-private-synchronous:sys-notify-song -u low -i ${iDIR}/music.png"
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		mpc -q toggle
	elif [[ "$1" == '--opt2' ]]; then
		mpc -q prev && ${notify_song} "$(mpc -f "%title%" current)"
	elif [[ "$1" == '--opt3' ]]; then
		mpc -q next && ${notify_song} "$(mpc -f "%title%" current)"
	elif [[ "$1" == '--opt4' ]]; then
		mpc -q stop
	elif [[ "$1" == '--opt5' ]]; then
		mpc -q repeat
	elif [[ "$1" == '--opt6' ]]; then
		mpc -q random
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
"${option_1}")
	run_cmd --opt1
	;;
"${option_2}")
	run_cmd --opt2
	;;
"${option_3}")
	run_cmd --opt3
	;;
"${option_4}")
	run_cmd --opt4
	;;
"${option_5}")
	run_cmd --opt5
	;;
"${option_6}")
	run_cmd --opt6
	;;
esac
