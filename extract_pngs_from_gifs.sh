#!/bin/bash
gifs=($(find . -type f | grep gif))
echo $gifs
for file in "${gifs[@]}"
do
  echo "processing ${file}"
  pngname=${file/gif/png}
  yes | ffmpeg -i $file -ss 00:00:00 -vframes 1 $pngname
  echo "finish processing $file to png"
done
echo "finish all"