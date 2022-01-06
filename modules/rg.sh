#!/usr/bin/env bash

is_installed() { cmd rg; }

install() {
    URL=$(gh_asset BurntSushi/ripgrep "ripgrep-.*-x86_64-unknown-linux-musl.tar.gz")
    curl "$URL" | tar xz
    mv -f ripgrep-*/rg "$BIN"
}
