#!/bin/bash

WALLPAPER_DIR="$HOME/.config/wallpapers"

readarray -t wallpapers < <(ls $WALLPAPER_DIR/ | sort -R | tail -2)

DISPLAY1=DP-2
DISPLAY2=DP-3
WALLPAPER1="$WALLPAPER_DIR/${wallpapers[0]}"
WALLPAPER2="$WALLPAPER_DIR/${wallpapers[1]}"

hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$WALLPAPER1"
hyprctl hyprpaper preload "$WALLPAPER2"
hyprctl hyprpaper wallpaper "$DISPLAY1,$WALLPAPER1"
hyprctl hyprpaper wallpaper "$DISPLAY2,$WALLPAPER2"
