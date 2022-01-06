#!/usr/bin/env bash

is_installed() { cmd kubectl; }

install() {
    VER=$(gh_ver kubernetes/kubernetes)
    URL=https://storage.googleapis.com/kubernetes-release/release/$VER/bin/linux/amd64/kubectl
    curl -o "$BIN/kubectl" "$URL"
    chmod +x "$BIN/kubectl"
}
