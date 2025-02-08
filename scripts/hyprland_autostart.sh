#!/bin/sh
[ ! -f /run/udev/data/+drm:card0-HDMI-A-1 ] &&
	sudo systemctl restart -q systemd-udev-trigger

sudo systemctl status NetworkManager | grep Active..active 1>/dev/null || sudo systemctl start NetworkManager &

while [ ! -f /run/udev/data/+drm:card0-HDMI-A-1 ]; do echo "waiting for drm" && sleep 0.2; done

[ -z "$USER" ] || export USER="$(id -n -u)"
[ -n "$UID" ] || export UID="$(id -u)"
[ -z "$TERM" ] && export TERM=linux
[ -z "$LOGNAME" ] && export LOGNAME="$USER"
[ -z "$HOME" ] && export HOME=/home/"$USER"
[ -z "$LANG" ] && export LANG=en_US.UTF-8
[ -z "$PATH" ] && export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
[ -z "$XDG_SEAT" ] && export XDG_SEAT=seat0
[ -z "$XDG_SESSION_TYPE" ] && export XDG_SESSION_TYPE=tty
[ -z "$XDG_SESSION_CLASS" ] && export XDG_SESSION_CLASS=user
[ -z "$XDG_VTNR" ] && export XDG_VTNR=1
[ -z "$XDG_RUNTIME_DIR" ] && export XDG_RUNTIME_DIR="/run/user/$UID"
[ -z "$DBUS_SESSION_BUS_ADDRESS" ] && export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID/bus"

export HYPRLAND_LOG_WLR=1
export XCURSOR_SIZE=24

# change the theme here
# export XCURSOR_THEME=Bibata-Modern-Classic
# export GTK_THEME=Adwaita-amoled-dark-Fix

[ ! -f /run/udev/data/+drm:card0-HDMI-A-1 ] &&
	echo "Hyprland needs drm, bailing out" && exit 1

exec Hyprland >.hyprland.log.txt 2>.hyprland.err.txt
