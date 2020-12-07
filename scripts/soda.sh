#! /bin/bash

# defaults to wpa/wpa2 hash cracking

# from https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash?page=1&tab=votes#tab-top

if [[ "$#" == "0" ]]; then
    echo "[USAGE] soda.sh [-o|--output-dir-base] [-w|--word-list] [-h|--hash]"
    echo "ex: soda.sh -o converted_pcaps -w ../word_lists/Top204Thousand-WPA-probable-v2.txt -h 22000" 
    # exit 1
fi

OUTPUT_DIR_BASE=""
WORD_LIST=""
HASH=""
PURPLE_RAIN="" # https://www.netmux.com/blog/purple-rain-attack
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -o|--output-dir-base)
            OUTPUT_DIR_BASE="$2"
            shift # past argument
            shift # past value
            ;;
        -w|--word-list)
            WORD_LIST="$2"
            shift # past argument
            shift # past value
            ;;
        -h|--hash)
            HASH="$2"
            shift
            shift
            ;;
        --purple-rain)
            PURPLE_RAIN="$2"
            shift 
            shift
            ;;
        *)    # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
            ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ "$OUTPUT_DIR_BASE" == "" ]]; then
    OUTPUT_DIR_BASE="converted_pcaps"
fi

if [[ ! -d "$OUTPUT_DIR_BASE" ]]; then
    echo "[ERROR] output directory for converted pcap files does not exit"
    exit 1
fi

if [[ "$WORLD_LIST" == "" ]]; then
    WORD_LIST="../word_lists/Top204Thousand-WPA-probable-v2.txt"
fi

if [[ "$HASH" == "" ]]; then
    HASH="22000"
fi

for file in $OUTPUT_DIR_BASE/*/*.hccapx; do
    # use purple rain attack that collects successful random rules
    if [[ "$PURPLE_RAIN" == "true" ]]; then
        shuf "$WORD_LIST" | pp64.bin --pw-min=8 | hashcat --debug-mode=1 --debug-file=success_purplerain.rule -a 0 -m "$HASH" "$file" -g 300000
        continue
    fi
    # default crack command
    hashcat -m "$HASH" "$file" "$WORD_LIST" 
done