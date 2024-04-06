#!/usr/bin/env bash
set -e
IFS=$'\t'

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

for file in ${selection}; do
	ffmpeg -i "$file" -vf scale=420:-2,format=yuv420p -n "${file%.*}.mp4"
	touch -r "$file" "${file%.*}.mp4"
done
