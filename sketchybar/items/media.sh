#!/bin/bash

sketchybar --add item mediaInfo center \
	--set mediaInfo label.color="$TEXT" \
	label.max_chars=20 \
	icon.padding_left=0 \
	scroll_texts=on \
	icon=􀑪 \
	icon.color="$TEXT" \
	background.drawing=off \
	script="$PLUGIN_DIR/media.sh" \
	--subscribe mediaInfo media_change

sketchybar --add item skipBackwards center \
	--set skipBackwards \
	icon=􀊊 \
	icon.padding_right=0 \
	label.drawing=off

sketchybar --add item playPause center \
	--set playPause \
	icon.padding_right=0 \
	icon.padding_left=0 \
	label.drawing=off \
	script="$PLUGIN_DIR/media.sh" \
	--subscribe playPause media_change

sketchybar --add item skipForwards center \
	--set skipForwards \
	icon=􀊌 \
	icon.padding_left=0 \
	label.drawing=off

sketchybar --add bracket mediaControls playPause skipForwards skipBackwards center \
	--set mediaControls \
	background.color="$TRANSPARENT" \
	background.border_width=1 \
	background.border_color="$SURFACE1"

sketchybar --add bracket media mediaInfo mediaControls center \
	--set media \
	label.drawing=off \
	icons.drawing=off \
	background.color="$SURFACE0"
