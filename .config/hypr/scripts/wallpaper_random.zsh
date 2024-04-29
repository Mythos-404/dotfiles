#!/usr/bin/env zsh

USER_SCRIPTS="$HOME/.config/hypr/scripts"

WALL_DIR="$HOME/Pictures/wallpapers"

# Transition config
FPS=144
TYPE="any"
DURATION=3
swwww_set_image() { swww img --transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION $1 }

IFS=$'\0'
PICS=($(fd -0 '.jpg$|.jpeg$|.png$|.gif$' "${WALL_DIR}"))
RANDOM_PIC="${PICS[$RANDOM % ${#PICS}]}"
unset IFS

swww query || swww init && swwww_set_image $RANDOM_PIC

sleep 0.5
"${USER_SCRIPTS}"/pywal_swww.zsh
sleep 0.2
"${USER_SCRIPTS}"/refresh_app.zsh
sleep 0.5
