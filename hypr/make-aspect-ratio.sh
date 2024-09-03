#!/bin/bash

desired_width=$1
desired_height=$2
desired_ratio=$(echo "scale=2;$1/$2" | bc)

read -r address width height < <(hyprctl activewindow -j | jq -rc '[.address, .size] | flatten | join(" ")')

expected_width=$(echo "($desired_ratio*$height)/1" | bc)
expected_height=$(echo "($width/$desired_ratio)/1" | bc)

if [[ $expected_width -gt $width ]]
then
	delta=$(echo "$expected_height - $height" | bc)
	hyprctl dispatch resizeactive "0 $delta"
else
	delta=$(echo "$expected_width - $width" | bc)
	echo "$delta 0,address:$address"
	hyprctl dispatch resizeactive "$delta 0"
fi
