#!/usr/bin/env bash

is_installed() {
    cmd zstd
}

install() {
    ZSTD_VER=$(latest facebook/zstd | sed -E "s/v//")
    ZSTD_URL=https://github.com/facebook/zstd/releases/download/v$ZSTD_VER/zstd-$ZSTD_VER.tar.gz
    curl "$ZSTD_URL" | tar xz
    make -C zstd-$ZSTD_VER -j"$(nproc)"
    mv zstd-$ZSTD_VER/programs/zstd* "$BIN"
}
