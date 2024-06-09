#!/bin/zsh

CURRENT_WS_ID=$(hyprctl activeworkspace -j | jq -r ".id")
TARGET_WS_ID="$1"
CURRENT_WS_WINDOWS=$(hyprctl clients -j | jq -r --arg id "$CURRENT_WS_ID" '.[] | select(.workspace.id == ($id | tonumber)) | .address')
TARGET_WS_WINDOWS=$(hyprctl clients -j | jq -r --arg id "$TARGET_WS_ID" '.[] | select(.workspace.id == ($id | tonumber)) | .address')

echo "$CURRENT_WS_WINDOWS" | xargs -I {} hyprctl dispatch movetoworkspacesilent "$TARGET_WS_ID",address:{}
echo "$TARGET_WS_WINDOWS" | xargs -I {} hyprctl dispatch movetoworkspacesilent "$CURRENT_WS_ID",address:{}
