#!/usr/bin/env bash

is_installed() { cmd micro; }

install() {
    URL=$(gh_asset zyedidia/micro "micro-.*-linux64.tar.gz")
    curl "$URL" | tar xz
    mv -f micro-*/micro "$BIN"
}
