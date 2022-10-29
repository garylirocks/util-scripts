#!/bin/env bash

set -eu

# video file name is the first parameter
VIDEO=$1

# shift off the first parameter and use others as breakpoints
shift
MID_BREAKPOINTS=$@

OUTPUT_DIR=${VIDEO%.*}_outputs

if [[ -d "${OUTPUT_DIR}" ]]; then
  rm -rf "${OUTPUT_DIR}"
fi
mkdir "${OUTPUT_DIR}"

START="00:00:00"
END=$(ffmpeg -hide_banner -i "${VIDEO}" 2>&1 | sed -r -n "s/^.*Duration: ([0-9:.]*),.*$/\1/p")

BREAKPOINTS=("${START}" ${MID_BREAKPOINTS[@]} "${END}")

# loop through an array
for (( i=0; i<$(( ${#BREAKPOINTS[@]} - 1 )); i++ )); do
  from=${BREAKPOINTS[$i]}
  next=$(( i+1 ))
  to=${BREAKPOINTS[$next]}
  ffmpeg -loglevel quiet -i "${VIDEO}" -ss "${from}" -to "${to}" -c:v copy -c:a copy -map_metadata 0 -y "${OUTPUT_DIR}/${VIDEO%.*}_${from//:/-}_${to//:/-}.mp4"
done
