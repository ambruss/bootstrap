#!/usr/bin/env bash

is_installed() { cmd duf; }

install() {
    URL=$(gh_asset muesli/duf "duf_.*_linux_x86_64.tar.gz")
    curl "$URL" | tar xz
    mv duf "$BIN"
}
