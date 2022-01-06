#!/usr/bin/env bash

is_installed() { cmd fzf; }

install() {
    URL=$(gh_asset junegunn/fzf "fzf-.*-linux_amd64.tar.gz")
    curl "$URL" | tar xz
    mv -f fzf "$BIN"
    rm -rf ~/.fzf
    gh_clone junegunn/fzf ~/.fzf
}
