# to-ogg
A simple bash script to convert your music collection to Ogg Vorbis using sox

## Usage
``` ./to_ogg.sh -i /user/music_collection -o /user/converted -t wav -s mp3 -q 6.5 -e jpg,png --nomedia```

This will convert all *.wav files in /user/music_collection to 6.5 quality Vorbis files in
/user/converted. Using these options, the script will copy mp3 files without transcoding,
and copy *.jpg and *.png files in a /assets directory while creating a .nomedia file so
images don't show as pictures ex. in an Android phone.

For more information type:

``` ./to_ogg.sh --help ```
