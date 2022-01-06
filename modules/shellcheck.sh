#!/usr/bin/env bash

OPTIONAL=true

is_installed() { cmd shellcheck; }

install() {
    URL=$(gh_asset koalaman/shellcheck "shellcheck-.*.linux.x86_64.tar.xz")
    curl "$URL" | tar xJ
    mv -f shellcheck-*/shellcheck "$BIN"
}
