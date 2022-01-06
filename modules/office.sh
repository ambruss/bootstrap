#!/usr/bin/env bash

OPTIONAL=true

is_installed() { cmd onlyoffice-desktopeditors; }

install() {
    DEB=onlyoffice-desktopeditors_amd64.deb
    URL=https://download.onlyoffice.com/install/desktop/editors/linux/$DEB
    curl -O "$URL"
    sudo dpkg --install "$DEB" || sudo apt-get install -fqqy
}
