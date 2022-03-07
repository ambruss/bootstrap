#!/usr/bin/env bash

is_installed() { cmd teleport; }

install() {
    VER=$(gh_ver gravitational/teleport releases)
    curl https://get.gravitational.com/teleport-$VER-linux-amd64-bin.tar.gz | tar xz
    cd teleport
    cp teleport tctl tsh "$BIN"
}
