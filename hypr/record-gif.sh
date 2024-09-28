#!/bin/bash

TMP_FILE_UNOPTIMIZED="/tmp/recording_unoptimized.gif"
TMP_PALETTE_FILE="/tmp/recording_palette.png"
TMP_FILE="/tmp/recording.gif"
TMP_MP4_FILE="/tmp/recording.mp4"
OUT_DIR=$HOME/gifs
APP_NAME="GIF recorder"

is_recorder_running() {
  pgrep -x wf-recorder >/dev/null
}

convert_to_gif() {
  ffmpeg -i "$TMP_MP4_FILE" -filter_complex "[0:v] palettegen" "$TMP_PALETTE_FILE"
  ffmpeg -i "$TMP_MP4_FILE" -i "$TMP_PALETTE_FILE" -filter_complex "[0:v] fps=10 [new];[new][1:v] paletteuse" "$TMP_FILE_UNOPTIMIZED"
  if [ -f "$TMP_PALETTE_FILE" ]; then
    rm "$TMP_PALETTE_FILE"
  fi
  if [ -f "$TMP_MP4_FILE" ]; then
    rm "$TMP_MP4_FILE"
  fi
}

notify() {
  notify-send -a "$APP_NAME" "$1"
}

optimize_gif() {
  gifsicle -O3 -i "$TMP_FILE_UNOPTIMIZED" -o "$TMP_FILE"
  if [ -f "$TMP_FILE_UNOPTIMIZED" ]; then
    rm "$TMP_FILE_UNOPTIMIZED"
  fi
}

if is_recorder_running; then
  kill $(pgrep -x wf-recorder)
else
  mkdir -p $OUT_DIR
  OUT_FILE=$OUT_DIR/$(date "+%Y_%m_%d_%H_%M_%S.gif")

  GEOMETRY=$(slurp)
  if [[ ! -z "$GEOMETRY" ]]; then
    if [ -f "$TMP_FILE" ]; then
      rm "$TMP_FILE"
    fi
    notify "Started capturing GIF to clipboard."
    timeout 30 wf-recorder -g "$GEOMETRY" -f "$TMP_MP4_FILE"
    if [ $? -eq 124 ]; then
      notify "Post-processing started. GIF capturing timed out."
    else
      notify "Post-processing started. GIF was stopped."
    fi
    convert_to_gif
    optimize_gif
    wl-copy -t image/png < $TMP_FILE
		mv $TMP_FILE $OUT_FILE
    notify "GIF capture completed. GIF saved to clipboard and $OUT_FILE"
  fi
fi
