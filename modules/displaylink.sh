#!/usr/bin/env bash

OPTIONAL=true

is_installed() { quiet modinfo evdi; }

install() {
    SITE=https://www.synaptics.com
    URL1=$SITE/products/displaylink-graphics/downloads/ubuntu
    URL2=$SITE$(curl "$URL1" | grep -Po "/node/\d+\?filetype=exe" | head -n1)
    URL3=$SITE$(curl "$URL2" | grep -Po "/sites/default/files/exe_files/.*?.zip")
    curl -o displaylink.zip "$URL3"
    unzip displaylink.zip
    chmod +x ./displaylink-driver*.run
    sudo ./displaylink-driver*.run
}
