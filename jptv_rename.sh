#!/bin/bash

file_type="*"

convert_to_lowercase() {
  case "$1" in
    ０) echo 0 ;;
    １) echo 1 ;;
    ２) echo 2 ;;
    ３) echo 3 ;;
    ４) echo 4 ;;
    ５) echo 5 ;;
    ６) echo 6 ;;
    ７) echo 7 ;;
    ８) echo 8 ;;
    ９) echo 9 ;;
    *) echo "$1" ;;
  esac
}

convert_to_lowercase_multiple_digits() {
  local result=""
  local digit
  for ((i=0; i<${#1}; i++)); do
    digit=$(convert_to_lowercase "${1:i:1}")
    result="$result$digit"
  done
  echo "$result"
}

process_jptv() {
  local src_dir="$1"
  local dst_dir="$2"

  find "$src_dir" -type f -name "*.$file_type" | while read -r src; do
    basename="${src##*/}"
    DST="${dst_dir}"

    if [ ! -d "$DST" ]; then
      mkdir -p "$DST"
    fi

    if [[ "$basename" =~ （([０-９]+)） ]]; then
      number="${BASH_REMATCH[1]}"
      number=$(convert_to_lowercase_multiple_digits "$number")
      number=$(printf "%03d" "$number")
    fi

    src_filename=$(basename "$src")
    extension="${src_filename##*.}"
    dst_filename="EP$number.$extension"

    cp -l "$src" "$DST/$dst_filename"
    echo "File copied: $DST/$dst_filename"
  done
}

while getopts "s:d:t:" opt; do
  case "$opt" in
    s) src_dir="$OPTARG" ;;
    d) dst_dir="$OPTARG" ;;
    t) file_type="$OPTARG" ;;
    *) echo "Usage: $0 -s <src_dir> -d <dst_dir> -t <file_type>"
       exit 1 ;;
  esac
done

if [ -z "$src_dir" ] || [ -z "$dst_dir" ]; then
  echo "Usage: $0 -s <src_dir> -d <dst_dir> -t <file_type>"
  exit 1
fi

process_jptv "$src_dir" "$dst_dir"