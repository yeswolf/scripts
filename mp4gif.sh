#!/bin/sh
function pause(){
 read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
}

name=${1/.mp4/@2x}
echo $name
echo "Creating tempdir..."
tempdir=$(mktemp -d)
echo "Created $tempdir, splitting into files..."
ffmpeg -i $1 -vf fps=4 $tempdir/%04d.png
echo "Done, opening tempdir..."
open $tempdir
pause
num=0
echo $test
for file in $(ls -v $tempdir/*.png); do
   mv "$file" "$tempdir/new_$(printf "%u" $num).png"
   let num=$num+1
done

echo "Making mp4 back..."
ffmpeg -r 4 -i $tempdir/new_%d.png -vcodec h264 -y -pix_fmt yuv420p $tempdir/result.mp4

palette="$tempdir/palette.png"
filters="fps=15,scale=-1:-1:flags=lanczos"
ffmpeg -v warning -i $tempdir/result.mp4 -vf "$filters,palettegen" -y $palette
ffmpeg -v warning -i $tempdir/result.mp4 -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $tempdir/result.gif
gifsicle -O3 $tempdir/result.gif -o $name.gif
echo "Cleaning up..."
rm -rf $tempdir
ffmpeg -i $name.gif -ss 00:00:00 -vframes 1 $name.png