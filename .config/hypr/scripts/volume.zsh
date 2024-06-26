#!/usr/bin/env zsh

# Scripts for volume controls for audio and mic

iDIR="$HOME/.config/swaync/icons"

# Get Volume
get_volume() {
	volume=$(pamixer --get-volume)
	if [[ "$volume" -eq "0" ]]; then
		echo "Muted"
	else
		echo "$volume%"
	fi
}

# Get icons
get_icon() {
	current=$(get_volume)
	if [[ "$current" == "Muted" ]]; then
		echo "$iDIR/volume-mute.png"
	elif [[ "${current%\%}" -le 30 ]]; then
		echo "$iDIR/volume-low.png"
	elif [[ "${current%\%}" -le 60 ]]; then
		echo "$iDIR/volume-mid.png"
	else
		echo "$iDIR/volume-high.png"
	fi
}

# Notify
notify_user() {
	if [[ "$(get_volume)" == "Muted" ]]; then
		notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low -i "$(get_icon)" "Volume: Muted"
	else
		notify-send -e -h int:value:"$(get_volume | sed 's/%//')" -h string:x-canonical-private-synchronous:volume_notif -u low -i "$(get_icon)" "Volume: $(get_volume)"
	fi
}

# Increase Volume
inc_volume() {
	if [[ "$(pamixer --get-mute)" == "true" ]] {
		pamixer -u && notify_user
	}
	pamixer -i "${1}" && notify_user
}

# Decrease Volume
dec_volume() {
	if [[ "$(pamixer --get-mute)" == "true" ]] {
		pamixer -u && notify_user
	}
	pamixer -d "${1}" && notify_user
}

# Toggle Mute
toggle_mute() {
	if [[ "$(pamixer --get-mute)" == "false" ]] {
		pamixer -m && notify-send -e -u low -i "$iDIR/volume-mute.png" "Volume Switched OFF"
	} elif [[ "$(pamixer --get-mute)" == "true" ]] {
		pamixer -u && notify-send -e -u low -i "$(get_icon)" "Volume Switched ON"
	}
}

# Toggle Mic
toggle_mic() {
	if [[ "$(pamixer --default-source --get-mute)" == "false" ]] {
		pamixer --default-source -m && notify-send -e -u low -i "$iDIR/microphone-mute.png" "Microphone Switched OFF"
	} elif [[ "$(pamixer --default-source --get-mute)" == "true" ]] {
		pamixer -u --default-source u && notify-send -e -u low -i "$iDIR/microphone.png" "Microphone Switched ON"
	}
}
# Get Mic Icon
get_mic_icon() {
	current=$(pamixer --default-source --get-volume)
	if [[ "$current" == "0" ]] {
		echo "$iDIR/microphone-mute.png"
	} else {
		echo "$iDIR/microphone.png"
	}
}

# Get Microphone Volume
get_mic_volume() {
	volume=$(pamixer --default-source --get-volume)
	if [[ "$volume" == "0" ]] {
		echo "Muted"
	} else {
		echo "$volume%"
	}
}

# Notify for Microphone
notify_mic_user() {
	volume=$(get_mic_volume)
	icon=$(get_mic_icon)
	notify-send -e -h int:value:"$volume" -h "string:x-canonical-private-synchronous:volume_notif" -u low -i "$icon" "Mic-Level: $volume"
}

# Increase MIC Volume
inc_mic_volume() {
	if [[ "$(pamixer --default-source --get-mute)" == "true" ]] {
		pamixer --default-source -u && notify_mic_user
	}
	pamixer --default-source -i "${1}" && notify_mic_user
}

# Decrease MIC Volume
dec_mic_volume() {
	if [[ "$(pamixer --default-source --get-mute)" == "true" ]] {
		pamixer --default-source -u && notify_mic_user
	}
	pamixer --default-source -d "${1}" && notify_mic_user
}

# Execute accordingly
case "$1" in
"--get")
	get_volume
	;;
"--inc")
	inc_volume "${2:-5}"
	;;
"--dec")
	dec_volume "${2:-5}"
	;;
"--toggle")
	toggle_mute
	;;
"--toggle-mic")
	toggle_mic
	;;
"--get-icon")
	get_icon
	;;
"--get-mic-icon")
	get_mic_icon
	;;
"--mic-inc")
	inc_mic_volume "${2:-5}"
	;;
"--mic-dec")
	dec_mic_volume "${2:-5}"
	;;
*)
	get_volume
	;;
esac
