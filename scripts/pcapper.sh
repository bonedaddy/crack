#! /bin/bash

# used to do bulk parsing of pcap files checking for crackable materials
# works best if pcap files are named in the format SSID_MAC 

PCAP_DIR="$1"
OUTPUT_DIR_BASE="$2"

if [[ "$OUTPUT_DIR_BASE" == "" ]]; then
    OUTPUT_DIR_BASE="converted_pcaps"
fi

if [[ ! -f "$OUTPUT_DIR_BASE" ]]; then
    mkdir "$OUTPUT_DIR_BASE"
fi

FILES=$(cd "$PCAP_DIR" && ls -l *.pcap  | awk '{print $NF}')

for file in $PCAP_DIR/*.pcap; do
    # filename expansion https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion
    JUST_NAME=${file##*/}
    JUST_NAME_NO_EXT=${JUST_NAME%.*}
    STORE_DIR="$OUTPUT_DIR_BASE/$JUST_NAME_NO_EXT"

    mkdir "$STORE_DIR"
    
    cp "$file" "$STORE_DIR"
    
    hcxpcapngtool --all -o "$STORE_DIR/capture.hccapx" "$STORE_DIR/$JUST_NAME"
    # if this fails we weren't able to capture any crackable materials 
    # so wipe out the data, however note that this might not be entirely accurate
    if [[ ! -f "$STORE_DIR/capture.hccapx" ]]; then
        # try cap2hccapx although this will likely also not work
        cap2hccapx "$STORE_DIR/$JUST_NAME" "$STORE_DIR/capture.hccapx"
        if [[ $(du -hs "$STORE_DIR/capture.hccapx" | awk '{print $1}') == 0 ]]; then
            echo "pcap conversion failed for $JUST_NAME_NO_EXT"
            rm -rf "$STORE_DIR"
        fi
    fi

done