#!/usr/bin/env bash

is_installed() { cmd diff-so-fancy; }

install() {
    URL=$(gh_asset so-fancy/diff-so-fancy diff-so-fancy)
    curl -o "$BIN/diff-so-fancy" "$URL"
    chmod +x "$BIN/diff-so-fancy"
}
