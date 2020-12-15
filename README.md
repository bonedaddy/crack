# crack

Hashcracking toolkit, including documentation, installation scripts, and utility scripts.

# usage wifi cracking

## brief

1) acquire pcap files
2) convert pcap files to hccapx files `baking.sh /path/to/pcaps /path/to/main_output_dir`
3) flick ya wrist `soda.sh /path/to/main_output_dir`

## detailed

After acquiring pcap files the `baking.sh` script reads pcap files from `/path/to/pcaps`. It then uses `/path/to/main_output_dir` as the base directory for storing converted hccapx files. Each pcap file gets it's own directory within `/path/to/main_output_dir`. Inside of this the pcap files along with their converted hccapx file are stored.

After conversion the `soda.sh` script reads all hccapx files, and attemps to crack them using `hashcat`. A default wordlist is provided in `word_lists` downloaded from [here](https://github.com/SnollyG0st3r/Probable-Wordlists/tree/master/Real-Passwords/WPA-Length). The soda script is pretty basic right now and is only intended to be used as a template until it is more customizable





# note

for educational purposes only