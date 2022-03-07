#!/usr/bin/env bash

is_installed() { cmd skaffold; }

install() {
    URL=https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
    curl -o "$BIN/skaffold" "$URL"
    chmod +x "$BIN/skaffold"
}
