#! /bin/bash

# used to do bulk conversion of pcap files into hccapx for use with hashcat
# additionally it stores a copy of all successfully converted hccapx files in a single file
# to do bulk cracking at once

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

# combined hccapx file
COMBINED_HCCAPX="$OUTPUT_DIR_BASE/combined.hccapx"

# parse over all pcap files
for file in $PCAP_DIR/*.pcap; do
    # filename expansion https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion
    JUST_NAME=${file##*/} # get just the filename
    JUST_NAME_NO_EXT=${JUST_NAME%.*} # strip the extension
    STORE_DIR="$OUTPUT_DIR_BASE/$JUST_NAME_NO_EXT" # directory to store the pcap and the hccapx file
    mkdir "$STORE_DIR"
    cp "$file" "$STORE_DIR"
    
    # capture all crackable key materials not just the best
    hcxpcapngtool \
        -o "$STORE_DIR/capture.hccapx" \
        -E "$STORE_DIR/capture.hccapx.essid_list" \
        -R "$STORE_DIR/capture.hccapx.probe_requests" \
        -I "$STORE_DIR/capture.hccapx.identity_list" \
        -U "$STORE_DIR/capture.hccapx.username_list" \
        --eapmd5="$STORE_DIR/capture.hccapx.eapmd5" \
        --tacacs-plus="$STORE_DIR/capture.hccapx.tacacs_plus" \
        --eapleap="$STORE_DIR/capture.eap_leap" \
        "$STORE_DIR/$JUST_NAME"
    
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

    # now prepare captured data tto generate a dynamic wordlist based off the captured data
    hcxeiutool \
        -i "$STORE_DIR/capture.hccapx.essid_list" \
        -d "$STORE_DIR/capture.hccapx.digit_list" \
        -x "$STORE_DIR/capture.hccapx.xdigit_list" \
        -c "$STORE_DIR/capture.hccapx.char_list" \
        -s "$STORE_DIR/capture.hccapx.sc_list"

    cat "$STORE_DIR/capture.hccapx.essid_list" "$STORE_DIR/capture.hccapx.xdigit_list" "$STORE_DIR/capture.hccapx.char_list" "$STORE_DIR/capture.hccapx.digit_list" "$STORE_DIR/capture.hccapx.sc_list" > "$STORE_DIR/capture.hccapx.word_listtmp"

    # run leetspeek and best64 rules against patricular charlist and sclist
    hashcat --stdout -r  ../rules/OneRuleToRuleThemAll.rule "$STORE_DIR/capture.hccapx.char_list" >> "$STORE_DIR/capture.hccapx.word_listtmp"
    hashcat --stdout -r ../rules/OneRuleToRuleThemAll.rule "$STORE_DIR/capture.hccapx.sc_list" >> "$STORE_DIR/capture.hccapx.word_listtmp"

    # sort the words, remove duplicates, shuffle output 
    cat "$STORE_DIR/capture.hccapx.word_listtmp" | sort | uniq | shuf > "$STORE_DIR/capture.hccapx.word_list"

    # remove extraneous files
    rm "$STORE_DIR/capture.hccapx.xdigit_list" "$STORE_DIR/capture.hccapx.char_list" "$STORE_DIR/capture.hccapx.sc_list" "$STORE_DIR/capture.hccapx.word_listtmp" "$STORE_DIR/capture.hccapx.digit_list"

done

# parse over all hccapx files
for file in $OUTPUT_DIR_BASE/*/*.hccapx; do
    cat "$file" >> "$COMBINED_HCCAPX"
done

mv "$COMBINED_HCCAPX" "$COMBINED_HCCAPX.temp"

sort -u "$COMBINED_HCCAPX.temp" -o "$COMBINED_HCCAPX"

rm "$COMBINED_HCCAPX.temp"