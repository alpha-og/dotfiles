#!/bin/bash

STATE="$(echo "$INFO" | jq -r '.state')"

if [ "$STATE" = "playing" ]; then
	MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
	sketchybar --set "$NAME" label="$MEDIA" drawing=on
	sketchybar --set playPause icon=􀊆
elif [ "$STATE" = "paused" ]; then
	MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
	sketchybar --set "$NAME" label="$MEDIA" drawing=on
	sketchybar --set playPause icon=􀊄
else
	sketchybar --set "$NAME" drawing=off
fi
