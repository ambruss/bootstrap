#!/usr/bin/env bash

OPTIONAL=true

is_installed() { cmd teamviewer; }

install() {
    URL=https://download.teamviewer.com/download/linux/teamviewer_i386.deb
    curl -O "$URL"
    sudo dpkg --install teamviewer_i386.deb || sudo apt-get install -fqqy
}
