#! /bin/bash

# used to do bulk parsing of pcap files checking for crackable materials
# works best if pcap files are named in the format SSID_MAC 

# directory containing pcap files
PCAP_DIR="$1"
# root directory where we will store pcaps and their corresponding hccapx files
OUTPUT_DIR_BASE="$2"

if [[ "$OUTPUT_DIR_BASE" == "" ]]; then
    OUTPUT_DIR_BASE="converted_pcaps"
fi

if [[ ! -d "$OUTPUT_DIR_BASE" ]]; then
    mkdir "$OUTPUT_DIR_BASE"
fi

# parse over all pcap files
for file in $PCAP_DIR/*.pcap; do
    # filename expansion https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion
    JUST_NAME=${file##*/} # get just the filename
    JUST_NAME_NO_EXT=${JUST_NAME%.*} # strip the extension
    STORE_DIR="$OUTPUT_DIR_BASE/$JUST_NAME_NO_EXT" # directory to store the pcap and the hccapx file
    mkdir "$STORE_DIR"
    cp "$file" "$STORE_DIR"
    
    # capture all crackable key materials not just the best
    hcxpcapngtool --all -o "$STORE_DIR/capture.hccapx" "$STORE_DIR/$JUST_NAME"
    
    # if the above fails we weren't able to capture any crackable materials 
    # however cap2hccapx might work, so try that as a fallback
    if [[ ! -f "$STORE_DIR/capture.hccapx" ]]; then
        # if cap2hccapx fails, then we probably did not capture any crackable materials
        # so nuke the data since it's useless
        cap2hccapx "$STORE_DIR/$JUST_NAME" "$STORE_DIR/capture.hccapx"
        if [[ $(du -hs "$STORE_DIR/capture.hccapx" | awk '{print $1}') == 0 ]]; then
            echo "pcap conversion failed for $JUST_NAME_NO_EXT"
            rm -rf "$STORE_DIR"
        fi
    fi

done