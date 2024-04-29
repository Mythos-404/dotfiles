#!/usr/bin/env zsh

# Script for changing blurs on the fly
notif="$HOME/.config/swaync/images/bell.png"

STATE=$(hyprctl -j getoption decoration:blur:size | jq ".int")

if [[ "${STATE}" == "8" ]] {
    hyprctl keyword decoration:blur:size 2
    hyprctl keyword decoration:blur:passes 1
    notify-send -e -u low -i $notif "Less blur"
} else {
    hyprctl keyword decoration:blur:size 8
    hyprctl keyword decoration:blur:passes 1
    notify-send -e -u low -i $notif "Normal blur"
}
