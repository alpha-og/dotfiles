#!/bin/bash

SIDS=(1 2 3 4 5 6 7 8 9 10)

for SID in "${SIDS[@]}"; do
	sketchybar --add space space."$SID" left \
		--set space."$SID" space="$SID" \
		icon="$SID" \
		label.font="sketchybar-app-font:Regular:13.0" \
		label.padding_right=15 \
		label.y_offset=-1 \
		background.height=24 \
		script="$PLUGIN_DIR/space.sh"
done

sketchybar --add bracket spaces '/space\..*/' \
	--set spaces icon.drawing=off \
	label.drawing=off \
	background.color="$SURFACE0" \
	background.height=26 \
	script="$PLUGIN_DIR/space-window.sh" \
	--subscribe spaces space_windows_change
