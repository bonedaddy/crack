# crack

Hashcracking toolkit, including documentation, installation scripts, and utility scripts.

# usage wifi cracking

## brief

1) acquire pcap files
2) convert pcap files to hccapx files `baking.sh /path/to/pcaps /path/to/main_output_dir`
3) flick ya wrist `soda.sh /path/to/main_output_dir`

## detailed


The `baking.sh` script is used to processed captured data and extract all possible key material. It can handle data captured from deauth attacks as well as association attacks.  It parses the captured data, and attempts to extract identity (username and password) information. In addition it uses all captured data to generate dynamic word lists, using the `OneRuleToRuleThemAll` hashcat rule. 

After conversion the `soda.sh` script reads all hccapx files, and attemps to crack them using `hashcat`. A default wordlist is provided in `word_lists` downloaded from [here](https://github.com/SnollyG0st3r/Probable-Wordlists/tree/master/Real-Passwords/WPA-Length). The soda script is pretty basic right now and is only intended to be used as a template until it is more customizable


# word lists

Included in `word_lists` are two different word lists, the Top 204K probable word list as well as a custom word list of mine that is derived from a few different word lists including the 204k probable one.

# note

for educational purposes only