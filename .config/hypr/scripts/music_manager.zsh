#!/usr/bin/env zsh

# Import Current Theme
RASI="$HOME/.config/rofi/config-music.rasi"

# Theme Elements
mpc_status="$(mpc status)"
if [[ $(echo "${mpc_status}" | wc -l) == 1 ]] {
	prompt='offline'
	mesg='mpd is offline'
} else {
	prompt="$(mpc -f "%artist%" current)"
	mesg="$(mpc -f "%file%" current)"
}

# Options
if [[ ${mpc_status} == *"[playing]"* ]] {
	option_1=""
} else {
	option_1=""
}
option_2=""
option_3=""
option_4=""
option_5=""
option_6=""

# Toggle Actions
active=''
urgent=''
# Repeat
if [[ ${mpc_status} == *"repeat: on"* ]] {
	active="-a 4"
} elif [[ ${mpc_status} == *"repeat: off"* ]] {
	urgent="-u 4"
} else {
	option_5=" Parsing Error"
}
# Random
if [[ ${mpc_status} == *"random: on"* ]] {
	[ -n "$active" ] && active+=",5" || active="-a 5"
} elif [[ ${mpc_status} == *"random: off"* ]] {
	[ -n "$urgent" ] && urgent+=",5" || urgent="-u 5"
} else {
	option_6=" Parsing Error"
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "${option_1}\n${option_2}\n${option_3}\n${option_4}\n${option_5}\n${option_6}" |
		rofi -dmenu \
			-p "${prompt}" \
			-mesg "${mesg}" \
			${active} ${urgent} \
			-markup-rows \
			-kb-accept-entry "space" \
			-theme "${RASI}"

}

# Execute Command
iDIR="$HOME/.config/swaync/icons"
notify_song() { notify-send -h string:x-canonical-private-synchronous:sys-notify-song -u low -i ${iDIR}/music.png $1 }

# Actions
chosen="$(run_rofi)"
case ${chosen} in
("${option_1}")
	mpc -q toggle
	;;
("${option_2}")
	mpc -q prev && notify_song "$(mpc -f "%title%" current)"
	;;
("${option_3}")
	mpc -q next && notify_song "$(mpc -f "%title%" current)"
	;;
("${option_4}")
	mpc -q stop
	;;
("${option_5}")
	mpc -q repeat
	;;
("${option_6}")
	mpc -q random
	;;
esac
