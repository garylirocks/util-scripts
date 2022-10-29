#!/bin/env bash

SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )

readarray rows < timestamps.txt

for row in "${rows[@]}";do
  arr=(${row})
  echo ${row}
  bash ${SCRIPT_DIR}/cut_by_breakpoints.sh ${arr[0]} ${arr[@]:1}
done

all_outputs_dir=$(mktemp -d ./outputs_XXXX)
mv *_outputs/* $all_outputs_dir

cd $all_outputs_dir
for i in ls *.mp4; do
  bash ${SCRIPT_DIR}/last_frame_as_cover.sh $i
done
