#! /bin/bash

# from https://github.com/G4lile0/ESP32-WiFi-Hash-Monster#how-guess-the-wifi-password-using-brute-force-attack

wget https://raw.githubusercontent.com/hashcat/hashcat-utils/master/src/cap2hccapx.c
gcc -o cap2hccapx cap2hccapx.c
