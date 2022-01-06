#!/usr/bin/env bash

OPTIONAL=true

is_installed() { cmd hadolint; }

install() {
    URL=$(gh_asset hadolint/hadolint hadolint-Linux-x86_64)
    curl -o "$BIN/hadolint" "$URL"
    chmod +x "$BIN/hadolint"
}
