#!/bin/bash

torrent_name="$1"
torrent_path="$2"

SRC=$torrent_path/$torrent_name
DST="/ssd/电视剧/御饭团 (2024)/Season 1"

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
  if [ "$torrent_path" == "$1" ]; then
    basename="${1##*/}"
    if [ ! -d "$DST" ]; then
      mkdir -p "$DST"
    fi
    if [[ "$torrent_name" =~ （([０-９]+)） ]]; then
      number="${BASH_REMATCH[1]}"
      number=$(convert_to_lowercase_multiple_digits "$number")
      number=$(printf "%03d" "$number")
    fi
    src_filename=$(basename "$SRC")
    extension="${src_filename##*.}"
    dst_filename="EP$number.$extension"

    cp -l "$SRC" "$DST/$dst_filename"
    exit 0
  fi
}

process_jptv "/ssd/feeds"





