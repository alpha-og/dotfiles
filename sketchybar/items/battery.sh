#!/bin/bash

sketchybar --add item battery right \
	--set battery update_freq=60 \
	script="$PLUGIN_DIR/battery.sh" \
	--subscribe battery power_source_change
