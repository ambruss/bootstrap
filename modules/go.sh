#!/usr/bin/env bash

is_installed() { cmd go; }

install() {
    VER=$(gh_ver golang/go)
    URL=https://dl.google.com/go/$VER.linux-amd64.tar.gz
    curl "$URL" | tar -xzC "$PREFIX"
}
