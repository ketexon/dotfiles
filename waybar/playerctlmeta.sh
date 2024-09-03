#!/bin/bash

input=$(playerctl metadata --format=$'{{ title }}\n{{ trunc(title, 30) }}\n{{ artist }}\n{{ trunc(artist, 20) }}\n{{ album }}\n{{ duration(position) }}' 2>/dev/null) || {
	# note: we put empty text here so waybar doesn't immediately delete the bar
	echo "{ \"class\": \"hidden\", \"text\": \" \" }"
	exit
}

if [ "$1" = "control" ]; then 
	echo "{ \"class\": \"\" }"
	exit
fi

IFS=$'\n'
arr=(${input//\"/\\\"})

title=${arr[0]}
title_trunc=${arr[1]}
artist=${arr[2]}
artist_trunc=${arr[3]}
album=${arr[4]}
position=${arr[5]}

tooltip="$title\r$artist\r$album"

echo "{ \"text\": \"$title_trunc - $artist_trunc - $position\", \"tooltip\": \"$tooltip\", \"class\": \"\" }"
# format='
# {{ markup_escape("{") }}
# "text": "{{ trunc(title,15) }}",
# {{ markup_escape("}") }}
# '
#
# playerctl metadata --format="$(echo $format | tr -d '\n')"
