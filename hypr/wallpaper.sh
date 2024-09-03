#!/bin/bash

hyprpaper &
sleep 2

CHANGE_INTERVAL=1800

while :
do
	$HOME/.config/hypr/switch-wallpaper.sh
	sleep $CHANGE_INTERVAL
done
