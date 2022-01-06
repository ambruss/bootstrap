#!/usr/bin/env bash

is_installed() { cmd sops; }

install() {
    URL=$(gh_asset mozilla/sops "sops-.*.linux")
    curl -o "$BIN/sops" "$URL"
    chmod +x "$BIN/sops"
}
