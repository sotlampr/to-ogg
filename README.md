# to-ogg
A simple bash script to convert your music collection to Ogg Vorbis using sox

## Usage
``` ./to_ogg.sh -i /user/music_collection -o /user/converted -t wav -Q 6.5 -e jpg,png --nomedia```

This will convert all *.wav files in /user/music_collection to 6.5 quality Vorbis files in
/user/converted. Using these options, the script will also copy *.jpg and *.png files, and
create a .nomedia file in the output directory so images don't show as pictures ex. in an Android phone.
