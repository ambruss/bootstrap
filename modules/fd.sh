#!/usr/bin/env bash

is_installed() { cmd fd; }

install() {
    URL=$(gh_asset sharkdp/fd "fd-.*-x86_64-unknown-linux-gnu.tar.gz")
    curl "$URL" | tar xz
    mv -f fd-*/fd "$BIN"
}
