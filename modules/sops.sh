#!/usr/bin/env bash

is_installed() {
    cmd sops
}

install() {
    VER=$(latest mozilla/sops | sed 's/v//')
    URL="https://github.com/mozilla/sops/releases/download/v$VER/sops-v$VER.linux"
    curl -o "$BIN/sops" "$URL"
    chmod +x "$BIN/sops"
}
