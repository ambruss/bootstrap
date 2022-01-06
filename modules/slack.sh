#!/usr/bin/env bash

OPTIONAL=true

is_installed() { cmd slack; }

install() {
    VER=$(web_asset https://slack.com/downloads/linux "Version $VRE" | semver)
    URL=https://downloads.slack-edge.com/releases/linux/$VER/prod/x64/slack-desktop-$VER-amd64.deb
    curl -O "$URL"
    sudo dpkg --install slack-desktop-*.deb || sudo apt-get install -fqqy
}
