#!/usr/bin/env bash
set -e
IFS=$'\t'

for file in ${selection}; do
	digest=$(md5sum "$file" | cut -d' ' -f1)
	mv "$file" "${file%/*}/${digest%% *}.${file##*.}"
done
