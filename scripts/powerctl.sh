#!/usr/bin/env bash
#
# Author: Athul Anoop
#
# This script is a customized/ adapted version of the script found here
# https://github.com/SuchithSridhar/nixos-dotfiles/blob/60b591a3f0d93c65ef9d25eb36e3a4f121bb3fb2/scripts/power-controls,
# which is used to manage power based controls on Hyprland

LOG_FILE=/tmp/powerctl/powerctl.log
WAIT_TIME=3 # time to wait before final command for a given operation is executed in seconds

function get_client_count() {
	hyprctl clients | grep -c "Window"
}

function powerctl_log() {
	if [[ -f $LOG_FILE ]]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S"): $1" >$LOG_FILE
	else
		echo "$(date +"%Y-%m-%d %H:%M:%S"): $1" >>$LOG_FILE
	fi
}

function close_apps() {
	# display notification about closing apps
	if [[ "$(get_client_count)" -gt 1 ]]; then
		powerctl_log "Closing all apps..."
	fi

	# synthesize commands to close all hyprland windows using hyprctl
	hyprcmds=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')

	# dispatch batch commands using hyprctl
	if [[ -f $LOG_FILE ]]; then
		powerctl_log "$(hyprctl --batch "$hyprcmds")"
	else
		powerctl_log "$(hyprctl --batch "$hyprcmds")"
	fi

	sleep "$WAIT_TIME"

	if [[ "$(get_client_count)" -eq "0" ]]; then
		powerctl_log "All apps closed successfully."
		return
	else
		powerctl_log "Some apps didn't close. Sending SIGTERM to all open apps."
		pids=($(hyprctl clients | grep pid | cut -d ':' -f 2))
		for pid in "${pids[@]}"; do
			powerctl_log "Sending SIGTERM to $pid"
			powerctl_log "$(kill "$pid")"
		done

		sleep "$WAIT_TIME"

		if [ "$(get_client_count)" -eq "0" ]; then
			powerctl_log "All apps closed successfully."
		else
			powerctl_log "Some apps couldnt be closed. Please close them manually."
			exit 1
		fi
	fi
}

case "$1" in
poweroff | shutdown)
	notify-send "powerctl" "Shutting down..."
	close_apps
	systemctl poweroff
	;;
reboot | restart)
	notify-send "powerctl" "Rebooting..."
	close_apps
	systemctl reboot
	;;
# suspend & hibernate are a bit jank as it stands, but works
suspend)
	hyprlock
	systemctl suspend
	;;

hibernate)
	hyprlock
	systemctl hibernate
	;;

logout)
	notify-send "powerctl" "Logging out..."
	close_apps
	hyprctl dispatch exit # exit hyprland
	;;

lock)
	notify-send "powerctl" "Locking screen..."
	sleep 1
	hyprlock
	;;

close)
	notify-send "powerctl" "Closing all apps..."
	close_apps
	;;
*)
	echo "Usage: $0 {shutdown|reboot|suspend|hibernate|logout|lock|close}"
	echo "Caution: Suspend and Hibernate are a bit jank as it stands, but are somewhat functional."
	exit 1
	;;
esac
