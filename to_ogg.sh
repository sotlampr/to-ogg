#!/bin/bash
# A simple script to batch convert a music collection to ogg vorbis files.
# Author: Sotiris Lamprinidis (sot.lampr@gmail.com)
# License: MIT


# Arguements
while [[ $# > 0 ]]; do
  key="$1"
  case $key in
    # specify an input folder
    -i| --input)
    IN_PATH="$2"
    shift;;
    # specify an output folder
    -o| --output)
    OUT_PATH="$2"
    shift;;
    # specify the input file type
    -t| --type)
    TYPE="$2"
    shift;;
    # specify the target Vorbis quality
    -q)
    Q="$2"
    shift;;
    # specify extra files
    -e| --extras)
    EXTRAS="$2"
    shift;;
    # Write a .nomedia file in each directory
    --nomedia)
    NOMEDIA=true
    shift;;
    # display the help
    -h| --help)
    H="1"
    printf "Utility to batch convert a music collection to Ogg Vorbis\n"
    printf "Example:\n"
    printf "\tto_ogg -i ~/music/rock -t wav -e jpg -q 2\n"
    printf "\t\twill convert all .wav files from ~/music/rock to\n"
    printf "\t\t~/music/rock_converted, to Vorbis quality 2 files and will\n"
    printf "\t\talso copy any .jpg files.\n"
    printf "Usage:\n"
    printf "\t to_ogg [OPTIONS]\n"
    printf "Options:\n"
    printf "\t -i| --input\tSpecify the input folder\n"
    printf "\t\tdefaults to the current directory\n"
    printf "\t -o| --output\tSpecify the output folder\n"
    printf "\t\tdefaults to {input directory}_converted/\n"
    printf "\t -t| --type\tSpecify the file type\n"
    printf "\t\tdefaults to flac\n"
    printf "\t -e| --extras\tSpecify extra files to move\n"
    printf "\t\tdefaults to jpg,png,pdf\n"
    printf "\t -q\tSpecify the target Vorbis quality\n"
    printf "\t\tdefaults to 6\n"
    printf "Notes:\n"
    printf "\tTo kill the script when running, press Ctrl-C twice in a rapid succession\n"
    ;;
  esac
  shift
done


# Test for empty variables and initialize with default values
if [ -z "$IN_PATH" ]; then
  IN_PATH="$(pwd)"; fi
if [ -z "$OUT_PATH" ]; then
  OUT_PATH="${IN_PATH%/}_converted"; fi
if [ -z "$TYPE" ]; then
  TYPE="flac"; fi
if [ -z "$Q" ]; then
  Q="6"; fi
if [ -z "$EXTRAS" ]; then
  EXTRAS="jpg,png,pdf"; fi


# Find all matching files in given directory and loop
echo "Converting, please be patient..."
find "$IN_PATH" -name "*.$TYPE" -print0 | while IFS= read -r -d '' file; do
  # Hack for exiting when pressing Ctrl - C twice
  sleep 0.1

  # Parse the directory the file resides in and create target directories
  TEMP=$(dirname "$file")
  DIR_OUT="$OUT_PATH/${TEMP#"$IN_PATH"}"

  # Create the directory in out_path if not exists
  if [ ! -f "$DIR_OUT" ]; then
    mkdir -p "$DIR_OUT"
    if [ "$NOMEDIA" = true ]; then
      touch "${DIR_OUT}/.nomedia"
    fi;
  fi;

  # Parse the file name
  TEMP=$(basename "$file")
  FILE_OUT="$DIR_OUT/${TEMP%.*}.ogg"

  # Perform the conversion
  sox "$file" -C$Q "$FILE_OUT" --multi-threaded
done

# Copy extra files
echo "Copying extra files..."
for filetype in $(echo $EXTRAS | sed "s/,/ /g"); do
  find "$IN_PATH" -name "*.$filetype" -print0 | while IFS= read -r -d '' file; do
    TEMP=$(dirname "$file")
    DIR_OUT="$OUT_PATH/${TEMP#"$IN_PATH"}"
    FILE_OUT="$DIR_OUT/$(basename "$file")"

    if [ ! -f "$FILE_OUT" ]; then
      cp "$file" "$FILE_OUT"
    fi
  done
done
