# crack

Hashcracking toolkit, including documentation, installation scripts, and utility scripts.

# usage (wifi cracking)

# acquiring packet captures for crackable key material

Within `caplets` there is a bettercap caplet named `bigdaddy.cap`. It starts wifi recon and anytime a new wifi access point is discovered, we attempt to associate with it, while anytime a new client station is discovered we attempt to deauthenticate it. This allows us to capture as much possible key material. Additionally every 15 seconds we attempt to deauthenticate all current access points. WiFi channels are hopped every 125ms, or every 250ms if both 2.4ghz and 5ghz bands are available.

## brief

1) acquire pcap files
2) convert pcap files to hccapx files `baking.sh /path/to/pcaps /path/to/main_output_dir`
3) flick ya wrist `soda.sh /path/to/main_output_dir`

## detailed


The `baking.sh` script is used to processed captured data and extract all possible key material. It can handle data captured from deauth attacks as well as association attacks.  It parses the captured data, and attempts to extract identity (username and password) information. In addition it uses all captured data to generate dynamic word lists, using the `OneRuleToRuleThemAll` hashcat rule. It essentially runs the following commands that are shown at the end of `hcxeiutool --help`:

```shell
$> hcxpcapngtool -o test.22000 -E elist dump.pcapng
$> hcxeiutool -i elist -d digitlist -x xdigitlist -c charlist -s sclist
$> cat elist digitlist xdigitlist charlist sclist > wordlisttmp
$> hashcat --stdout -r <rule> charlist >> wordlisttmp
$> hashcat --stdout -r <rule> sclist >> wordlisttmp
$> cat wordlisttmp | sort | uniq > wordlist
```

After conversion the `soda.sh` script reads all hccapx files, and attemps to crack them using `hashcat`. A default wordlist is provided in `word_lists` downloaded from [here](https://github.com/SnollyG0st3r/Probable-Wordlists/tree/master/Real-Passwords/WPA-Length). The soda script is pretty basic right now and is only intended to be used as a template until it is more customizable


# word lists

Included in `word_lists` are two different word lists, the Top 204K probable word list as well as a custom word list of mine that is derived from a few different word lists including the 204k probable one.

# note

for educational purposes only