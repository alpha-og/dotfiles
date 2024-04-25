#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

if [ "$SELECTED" = true ]; then
	sketchybar --set "$NAME" background.drawing=on \
		background.color="$MAUVE" \
		label.color="$BASE" \
		icon.color="$BASE"
else
	sketchybar --set "$NAME" background.drawing=off \
		label.color="$SUBTEXT0" \
		icon.color="$SUBTEXT0"
fi
