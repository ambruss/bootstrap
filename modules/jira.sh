#!/usr/bin/env bash

OPTIONAL=true

is_installed() { cmd jira; }

install() {
    URL=$(gh_asset go-jira/jira jira-linux-amd64)
    curl -o "$BIN/jira" "$URL"
    chmod +x "$BIN/jira"
}
