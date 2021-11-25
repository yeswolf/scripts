#!/bin/bash
rm -rf $1_out
mkdir $1_out
ffmpeg -i $1.gif -vf fps=4 $1_out/out%d.png
ffmpeg -r 4 -i $1_out/out%d.png -vcodec h264 -y -pix_fmt yuv420p $1.mp4