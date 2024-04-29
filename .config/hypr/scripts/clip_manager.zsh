#!/usr/bin/env zsh

TMP_DIR="/tmp/cliphist"
rm -rf $TMP_DIR

mkdir -p $TMP_DIR

read -r -d '' prog <<EOF
/^[0-9]+\s<meta http-equiv=/ { next }
match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    system("echo " grp[1] "\\\\\t | cliphist decode >$TMP_DIR/"grp[1]"."grp[3])
    print \$0"\0icon\x1f$TMP_DIR/"grp[1]"."grp[3]
    next
}
1
EOF

while (true) {
	result=$(rofi -dmenu -config ~/.config/rofi/config-clipboard.rasi < <(cliphist list | gawk $prog))

	case $result {
	("")
		exit 0
		;;
	(*)
		cliphist decode <<<$result | wl-copy
		exit 0
		;;
	}
}
