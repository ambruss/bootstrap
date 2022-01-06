#!/usr/bin/env bash

is_installed() { cmd transcrypt; }

install() {
    VER=$(gh_ver elasticdog/transcrypt)
    URL=https://raw.githubusercontent.com/elasticdog/transcrypt/$VER/transcrypt
    curl -O "$URL"
    mv -f transcrypt "$BIN"
    chmod +x "$BIN/transcrypt"
}
