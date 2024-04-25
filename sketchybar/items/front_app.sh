#!/bin/bash

sketchybar --add item front_app center \
	--set front_app background.color="$SURFACE0" \
	icon.font="sketchybar-app-font:Regular:13.0" \
	icon.color="$TEXT" \
	label.color="$TEXT" \
	script="$PLUGIN_DIR/front_app.sh" \
	--subscribe front_app front_app_switched
