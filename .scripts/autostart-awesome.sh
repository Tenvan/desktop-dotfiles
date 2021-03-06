#!/usr/bin/env bash

. ~/.scripts/defs.zsh

run ibus-daemon -d -x

run unclutter --root --timeout 3

# Sound Tray Icons
restart start-pulseaudio-x11
restart pasystray
run .bin/volume-osd

killall blueman-tray
killall blueman-applet
# run blueman-tray
restart blueman-applet

run xscreensaver

restart alttab -n 1

run system-config-printer-applet

killall -q picom
sleep 1
sh $SCRIPTS/picom-toggle-awesome.sh &

killall xfce-polkit
sleep 1
run /usr/lib/xfce-polkit/xfce-polkit
# run lxqt-policykit-agent

if [ $IS_MANJARO = true -o $IS_GARUDA = true ]; then
	run msm_notifier
fi

#cursor active at boot
run xsetroot -cursor_name left_ptr -bg "#2a2a2a" -fg "#d6d6d6"
