#! /bin/bash

OUTPUT_DIR_BASE="$1"

if [[ "$OUTPUT_DIR_BASE" == "" ]]; then
    OUTPUT_DIR_BASE="converted_pcaps"
fi

if [[ ! -f "$OUTPUT_DIR_BASE" ]]; then
    echo "[ERROR] output directory for converted pcap files does not exit"
    exit 1
fi

for file in $OUTPUT_DIR_BASE/*/*.hccapx; do
    echo "$file"
done