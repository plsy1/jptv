#!/bin/sh

process_ts_files() {
    echo "Current directory: $(pwd)"
    echo "TS files in this directory: $(ls *.ts)"
    
    for ts_file in *.ts; do
        filename=$(basename -- "$ts_file")
        filename="${filename%.*}"

        if [ "$subtitle_format" = "ass" ]; then
            if [ -f "${filename}.ja.ass" ]; then
                echo "ASS file ${filename}.ja.ass already exists. Skipping ${ts_file}."
            else
                /home/y1/ffmpeg/ffmpeg -analyzeduration 10MB -probesize 10MB -fix_sub_duration -ignore_background 1 -itsoffset "$itsoffset" -i "$ts_file" -c:s ass "${filename}.ja.ass"
                sed -i 's/100,100/75,100/' "${filename}.ja.ass"
            fi
        elif [ "$subtitle_format" = "srt" ]; then
            if [ -f "${filename}.ja.srt" ]; then
                echo "SRT file ${filename}.ja.srt already exists. Skipping ${ts_file}."
            else
                /home/y1/ffmpeg/ffmpeg -analyzeduration 10MB -probesize 10MB -fix_sub_duration -ignore_background 1 -itsoffset "$itsoffset" -i "$ts_file" -c:s text "${filename}.ja.srt"
            fi
        fi
    done


    for subdir in */; do
        if [ -d "$subdir" ]; then
            cd "$subdir" || exit
            process_ts_files
            cd ..
        fi
    done
}

main() {
    local root_dir=""
    local itsoffset=0  
    local subtitle_format="" 

    while getopts "d:o:t:" opt; do
        case "$opt" in
            d) root_dir="$OPTARG" ;;
            o) itsoffset="$OPTARG" ;;
            t) subtitle_format="$OPTARG" ;; 
            *) echo "Usage: $0 -d <root_dir> [-o <itsoffset>] -t <ass|srt>"
               exit 1 ;;
        esac
    done

    if [ -z "$root_dir" ]; then
        echo "Usage: $0 -d <root_dir> [-o <itsoffset>] -t <ass|srt>"
        exit 1
    fi

    if [ -z "$subtitle_format" ] || { [ "$subtitle_format" != "ass" ] && [ "$subtitle_format" != "srt" ]; }; then
        echo "Error: -t must be either 'ass' or 'srt'."
        exit 1
    fi

    if [ ! -d "$root_dir" ]; then
        echo "Error: Directory $root_dir does not exist."
        exit 1
    fi

    cd "$root_dir" || exit
    process_ts_files
}

main "$@"