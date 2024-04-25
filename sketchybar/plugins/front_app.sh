#!/bin/bash

if [ "$SENDER" = "front_app_switched" ]; then
	sketchybar --set "$NAME" icon="$("$CONFIG_DIR"/plugins/icon_map_fn.sh "$INFO")" label="$INFO"
fi
