#!/usr/bin/env bash

is_installed() { cmd zstd; }

install() {
    URL=$(gh_asset facebook/zstd "zstd-.*.tar.gz")
    curl "$URL" | tar xz
    make -C zstd-* -j"$(nproc)"
    mv zstd-*/programs/zstd* "$BIN"
}
