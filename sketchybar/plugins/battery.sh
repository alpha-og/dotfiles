#!/bin/bash

source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
STATUS="$(pmset -g batt | grep -Eo "discharging|charging")"
ESTIMATE="$(pmset -g batt | grep -Eo "no estimate|(\d+:\d+)")"

if [ "$STATUS" = "charging" ]; then
	battery=(
		icon=􀢋
		icon.color="$GREEN"
	)
else
	if [ "$PERCENTAGE" -gt 75 ]; then
		battery=(
			icon=􀛨
			icon.color="$GREEN"
		)
	elif [ "$PERCENTAGE" -gt 50 ]; then
		battery=(
			icon=􀺸
			icon.color="$YELLOW"
		)
	elif [ "$PERCENTAGE" -gt 25 ]; then
		battery=(
			icon=􀺶
			icon.color="$PEACH"
		)
	elif [ "$PERCENTAGE" -gt 0 ]; then
		battery=(
			icon=􀛪
			icon.color="$RED"
		)
	fi
fi

sketchybar --set "$NAME" label="${PERCENTAGE}%" "${battery[@]}"
