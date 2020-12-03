#! /bin/bash

# you will want to customize this to use different word lists
# only designed to crack WPA secrets

OUTPUT_DIR_BASE="$1"

if [[ "$OUTPUT_DIR_BASE" == "" ]]; then
    OUTPUT_DIR_BASE="converted_pcaps"
fi

if [[ ! -d "$OUTPUT_DIR_BASE" ]]; then
    echo "[ERROR] output directory for converted pcap files does not exit"
    exit 1
fi

for file in $OUTPUT_DIR_BASE/*/*.hccapx; do
    hashcat -m 22000 "$file" ../word_lists/Top204Thousand-WPA-probable-v2.txt
done