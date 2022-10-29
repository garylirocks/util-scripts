# README

This repo contains some utility scripts

## Video scripts

*These scripts use `ffmpeg` to process videos*

- `last_frame_as_cover.sh`

  Some platforms (eg. Google Photos), use the first frame of a video as the cover image, but sometimes it makes more sense to use the last frame, this script fix this: grabs the last frame and put it at the beginning of the video

  ```sh
  bash last_frame_as_cover.sh video.mp4
  ```

- `cut_by_breakpoints.sh`

  Cut a video to segments by breakpoints, set the breakpoints as the second parameter
    - use format "hh:mm:ss.SS"
    - separate breakpoints by a space
    - enclose them in double quotes

  ```sh
  bash cut_by_breakpoints.sh video.mp4 "00:00:08.75 00:00:15.00"
  ```

- `batch.sh`

  Batch processing files.

  1. Copy `timestamps-example.txt` to your working directory, rename it to `timestamps.txt`
  2. Add video file name and breakpoints in it, follow the example format, one video file per line
  3. Run `bash /path/to/batch_cut_and_fix_cover.sh`
