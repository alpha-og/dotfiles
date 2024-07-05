#!/bin/bash

STATE="$(echo "$INFO" | jq -r '.state')"

if [ "$STATE" = "playing" ] || [ "$STATE" = "paused" ]; then
	sketchybar --set media drawing=on
	sketchybar --set skipBackwards drawing=on
	sketchybar --set playPause drawing=on
	sketchybar --set skipForwards drawing=on
	sketchybar --set mediaControls drawing=on
	sketchybar --set media drawing=on
fi

if [ "$STATE" = "playing" ]; then
	if [ "$NAME" = "mediaInfo" ]; then
		MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
		sketchybar --set mediaInfo label="$MEDIA" drawing=on
	elif [ "$NAME" = "playPause" ]; then
		sketchybar --set playPause icon=􀊆 drawing=on
	fi

elif [ "$STATE" = "paused" ]; then
	if [ "$NAME" = "mediaInfo" ]; then
		MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
		sketchybar --set mediaInfo label="$MEDIA" drawing=on
	elif [ "$NAME" = "playPause" ]; then
		sketchybar --set playPause icon=􀊄 drawing=on
	fi
else
	sketchybar --set mediaInfo drawing=off
	sketchybar --set skipBackwards drawing=off
	sketchybar --set playPause drawing=off
	sketchybar --set skipForwards drawing=off
	sketchybar --set mediaControls drawing=off
	sketchybar --set media drawing=off
fi
