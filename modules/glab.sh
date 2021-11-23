#!/usr/bin/env bash

is_installed() {
    cmd glab
}

install() {
    GLAB_VER=$(latest profclems/glab | sed s/v//)
    GLAB_URL=https://github.com/profclems/glab/releases/download/v$GLAB_VER/glab_${GLAB_VER}_Linux_x86_64.tar.gz
    curl "$GLAB_URL" | tar xz bin/glab
    mv -f bin/glab "$BIN"
}
