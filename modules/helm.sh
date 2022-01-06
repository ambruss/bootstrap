#!/usr/bin/env bash

is_installed() { cmd helm; }

install() {
    VER=$(gh_ver helm/helm)
    curl "https://get.helm.sh/helm-$VER-linux-amd64.tar.gz" | tar xz
    mv -f linux-amd64/helm "$BIN"
}
