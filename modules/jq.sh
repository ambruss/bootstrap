#!/usr/bin/env bash

is_installed() { cmd jq; }

install() {
    URL=$(gh_asset stedolan/jq jq-linux64)
    curl -o "$BIN/jq" "$URL"
    chmod +x "$BIN/jq"
}
