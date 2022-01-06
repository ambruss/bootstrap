#!/usr/bin/env bash

is_installed() { cmd exa; }

install() {
    URL=$(gh_asset ogham/exa "exa-linux-x86_64-.*.zip")
    curl -O "$URL"
    unzip exa-*.zip
    mv -f bin/exa "$BIN"
}
