#!/usr/bin/env bash

is_installed() { cmd hexyl; }

install() {
    URL=$(gh_asset sharkdp/hexyl "hexyl-.*-x86_64-unknown-linux-gnu.tar.gz")
    curl "$URL" | tar xz
    mv -f hexyl-*/hexyl "$BIN"
}
