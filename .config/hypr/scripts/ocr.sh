#!/usr/bin/env bash

# OCR for tesseract

CACHE_DIR="/tmp/ocr"
RASI="$HOME/.config/rofi/config-music.rasi"

[[ ! -d ${CACHE_DIR} ]] && mkdir -p ${CACHE_DIR}

rofi_run() {
	echo -e "EN\nCN" | rofi -theme-str 'textbox-prompt-colon {str: "";}' \
		-theme-str "window {width: 300px;}" \
		-dmenu \
		-p "OCR" \
		-markup-rows \
		-kb-accept-entry "space" \
		-theme "${RASI}"
}

ocr_lang() {
	grim -l 0 -g "$(slurp)" - >${CACHE_DIR}/temp_png
	tesseract -l "${1}" ${CACHE_DIR}/temp_png ${CACHE_DIR}/temp && cat ${CACHE_DIR}/temp.txt | wl-copy
}

lang=$([[ ${1} == "" ]] && rofi_run || echo "${1}")

case "${lang}" in
--cn | CN)
	ocr_lang chi_sim
	;;
--en | EN)
	ocr_lang eng
	;;
esac
