#!/usr/bin/env bash

is_installed() { cmd skaffold; }

install() {
    URL=$(gh_asset GoogleContainerTools/skaffold skaffold-linux-amd64)
    curl -o "$BIN/skaffold" "$URL"
    chmod +x "$BIN/skaffold"
}
