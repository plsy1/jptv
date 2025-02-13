#!/bin/sh

process_ts_files() {
    echo "Current directory: $(pwd)"
    echo "TS files in this directory: $(ls *.ts)"
    
    for ts_file in *.ts; do
        filename=$(basename -- "$ts_file")
        filename="${filename%.*}"

        if [ -f "${filename}.ja.srt" ]; then
            echo "SRT file ${filename}.ja.srt already exists. Skipping ${ts_file}."
        else
            ffmpeg -analyzeduration 10000000 -probesize 10000000 -fix_sub_duration -itsoffset "$itsoffset" -i "$ts_file" -c:s text "${filename}.ja.srt"
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

    while getopts "d:o:" opt; do
        case "$opt" in
            d) root_dir="$OPTARG" ;;
            o) itsoffset="$OPTARG" ;;
            *) echo "Usage: $0 -d <root_dir> [-o <itsoffset>]"
               exit 1 ;;
        esac
    done

    if [ -z "$root_dir" ]; then
        echo "Usage: $0 -d <root_dir> [-o <itsoffset>]"
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