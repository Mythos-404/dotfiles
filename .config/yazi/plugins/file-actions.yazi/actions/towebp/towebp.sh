#!/usr/bin/env bash
set -e
IFS=$'\t'

{
	for file in ${selection}; do
		echo "$file"
	done
} | xargs -I{} -P 0 bash -c 'magick ${1} -quality ${quality} $([ "$lossless" = true ] && echo "-define webp:lossless=true") ${1%.*}.webp && touch -r ${1} ${1%.*}.webp' bash {}
