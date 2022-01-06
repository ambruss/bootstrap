#!/usr/bin/env bash

is_installed() { cmd jo; }

install() {
    URL=$(gh_asset skanehira/gjo Linux.zip)
    curl -O "$URL"
    unzip Linux.zip
    mv -f gjo "$BIN/jo"
}
