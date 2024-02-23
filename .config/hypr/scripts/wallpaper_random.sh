#!/usr/bin/env bash

USER_SCRIPTS="$HOME/.config/hypr/scripts"

WALL_DIR="$HOME/Pictures/wallpapers"

# Transition config
FPS=60
TYPE="random"
DURATION=1
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

mapfile -t PICS < <(eza "$WALL_DIR" | rg ".jpg$|.jpeg$|.png$|.gif$")
RANDOM_PIC="${PICS[$RANDOM % ${#PICS[@]}]}"

swww query || swww init && swww img "${WALL_DIR}/${RANDOM_PIC}" "${SWWW_PARAMS}"

sleep 0.5
"${USER_SCRIPTS}"/pywal_swww.sh
sleep 0.2
"${USER_SCRIPTS}"/refresh_app.sh
sleep 0.5
