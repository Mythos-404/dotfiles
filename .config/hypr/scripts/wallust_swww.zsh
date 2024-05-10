#!/usr/bin/env zsh

# Pywal Colors for current wallpaper

# Define the path to the swww cache directory
cache_dir="$HOME/.cache/swww/"

# Get a list of monitor outputs
monitor_outputs=($(ls $cache_dir))

# Initialize a flag to determine if the ln command was executed
ln_success=false

# Loop through monitor outputs
for output ($monitor_outputs) {
	# Construct the full path to the cache file
	cache_file=${cache_dir}${output}

	# Check if the cache file exists for the current monitor output
	if [[ -f $cache_file ]] {
		# Get the wallpaper path from the cache file
		wallpaper_path=$(cat $cache_file)

		# Copy the wallpaper to the location Rofi can access
		if (ln -sf "$wallpaper_path" "$HOME/.config/rofi/.current_wallpaper") {
			ln_success=true # Set the flag to true upon successful execution
		}

		break # Exit the loop after processing the first found monitor output
	}
}

# Check the flag before executing further commands
if [[ $ln_success == true ]] {
	# execute wallust skipping tty and terminal changes
	wallust run -s "${wallpaper_path}" &
}
