#!/usr/bin/env bash

is_installed() { cmd glab; }

install() {
    URL=$(gh_asset profclems/glab "glab_.*_Linux_x86_64.tar.gz")
    curl "$URL" | tar xz
    mv -f bin/glab "$BIN"
}
