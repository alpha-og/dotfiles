#!/usr/bin/env zsh
#
# Author: Athul Anoop 
#
# This script is a customized/ adapted version of the script found here https://github.com/SuchithSridhar/nixos-dotfiles/blob/60b591a3f0d93c65ef9d25eb36e3a4f121bb3fb2/scripts/power-controls, which is used to manage power based controls on Hyprland
# These are operations like shutdown, lock, and logout.
# 
# Before performing some of these operations we handle the closing of apps.
# If there are apps that can't be closed without losing data, then the power operation
# is cancelled and a notification about the cause of the cancellation is sent.

function close_apps() {
    # display notification about closing apps
    client_count=$(hyprctl clients | grep "Window" | wc -l)
    if [[ "$client_count" -gt 1 ]]
    then
        notify-send "powerctl" "Closing Applications..."
    fi
    sleep 3

    # close all client windows
    # required for graceful exit since many apps aren't good SIGNAL citizens
    HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
    if [[ -f /tmp/hypr/hyprexitwithgrace.log ]]
    then
        hyprctl --batch "$HYPRCMDS" >> /tmp/hypr/hyprexitwithgrace.log 2>&1
    else
        hyprctl --batch "$HYPRCMDS" > /tmp/hypr/hyprexitwithgrace.log 2>&1
    fi

    sleep 2

    client_count=$(hyprctl clients | grep "class:" | wc -l)
    if [ "$client_count" -eq "0" ]; then
        notify-send "power controls" "Applications closed successfully."
        return
    else
        notify-send "power controls" "Some apps didn't close. Shutdown aborted."
        exit 1
    fi
}

case "$1" in
        shutdown)
                close_apps
                systemctl poweroff
             ;;
        reboot | restart)
                close_apps
                systemctl reboot
            ;;

        suspend)
            hyprlock
            sleep 3
            systemctl suspend
            ;;

        hibernate)
            hyprlock
            systemctl hibernate
            ;;

        logout)
            close_apps
            hyprctl dispatch exit
            ;;

        lock)
            hyprlock
            ;;

        close)
            close_apps
            ;;
        *)
            echo $"Usage: $0 {shutdown|reboot|suspend|hibernate|logout|lock|close}"
            exit 1
esac

