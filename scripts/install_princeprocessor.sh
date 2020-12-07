#! /bin/bash
INSTALL_DIR="$HOME/bin"
git clone https://github.com/hashcat/princeprocessor.git
cd princeprocessor/src
make -j$(nproc)
cp pp64.bin "$INSTALL_DIR"
cd -
rm -rf princeprocessor
