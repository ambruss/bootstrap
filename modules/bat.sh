#!/usr/bin/env bash

is_installed() { cmd bat; }

install() {
    URL=$(gh_asset sharkdp/bat "bat-.*-x86_64-unknown-linux-gnu.tar.gz")
    curl "$URL" | tar xz
    mv -f bat-*/bat "$BIN"
}
