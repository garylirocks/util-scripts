#!/bin/env bash

set -eu

OUTPUT_DIR=cover_fixed

if [[ ! -d ${OUTPUT_DIR} ]]; then
  mkdir ${OUTPUT_DIR}
fi

INPUT=$1
INPUT_TS=${INPUT%.*}.ts
OUTPUT=${OUTPUT_DIR}/${INPUT%.*}.mp4

FPS=$(ffmpeg -i "${INPUT}" 2>&1 | sed -n "s/.*, \(.*\) fps.*/\1/p")
MEDIA_CREATION_TIME=$(ffmpeg -i "${INPUT}" 2>&1 | sed -r -n "s/^.*creation_time *: (.*)$/\1/p" | head -1)

COVER_IMAGE=${INPUT%.*}_cover.jpg
COVER_VIDEO=${COVER_IMAGE%.*}.mp4
COVER_TS=${COVER_IMAGE%.*}.ts

# get the last frame as an image
# seek 0.1s from the end of the file
ffmpeg -sseof -0.1 -i "${INPUT}" -vsync 0 -q:v 31 -update true -y "${COVER_IMAGE}"

# create a short video from the cover image
ffmpeg -loop 1 -framerate "${FPS}" -i "${COVER_IMAGE}" -c:v libx264 -t 0.01 -pix_fmt yuv420p -y "${COVER_VIDEO}"

# convert videos to MPEG-2 transport stream
ffmpeg -i "${COVER_VIDEO}" -c copy -bsf:v h264_mp4toannexb -f mpegts "${COVER_TS}"
ffmpeg -i "${INPUT}" -c copy -bsf:v h264_mp4toannexb -f mpegts "${INPUT_TS}"

# output, keep media creation time
ffmpeg -i "concat:${COVER_TS}|${INPUT_TS}" -c copy -bsf:a aac_adtstoasc -metadata creation_time="${MEDIA_CREATION_TIME}" -y "${OUTPUT}"

# clean up
rm "${COVER_IMAGE}" "${COVER_VIDEO}" "${COVER_TS}" "${INPUT_TS}"
