#!/usr/bin/env zsh

# Polkit possible paths files to check
polkit=(
	"/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
	"/usr/lib/polkit-kde-authentication-agent-1"
)

executed=false # Flag to track if a file has been executed

# Loop through the list of files
for file ($polkit) {
	if [[ -e $file ]] {
		echo "File $file found, executing command..."
		"$file"
		executed=true
		break
	}
}

# If none of the files were found, you can add a fallback command here
if [[ "$executed" == false ]] {
	echo "None of the specified files were found. Install a Polkit"
}
