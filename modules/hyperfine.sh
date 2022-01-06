#!/usr/bin/env bash

is_installed() { cmd hyperfine; }

install() {
    URL=$(gh_asset sharkdp/hyperfine "hyperfine-.*-x86_64-unknown-linux-gnu.tar.gz")
    curl "$URL" | tar xz
    mv -f hyperfine-*/hyperfine "$BIN"
}
