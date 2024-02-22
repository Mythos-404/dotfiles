#!/usr/bin/env bash

CONFIG="$HOME/.config/swaylock/config"

pkill swaylock; sleep 0.5; swaylock --config "${CONFIG}" & disown
