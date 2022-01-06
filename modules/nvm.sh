#!/usr/bin/env bash

is_installed() { cmd nvm; }

install() {
    VER=$(gh_ver nvm-sh/nvm)
    URL=https://raw.githubusercontent.com/nvm-sh/nvm/$VER/install.sh
    unset PREFIX
    curl "$URL" | bash
    . "$HOME/.nvm/nvm.sh"
    nvm install node
    for PACKAGE in "${NPM_PACKAGES[@]}"; do
        npm install --global "$PACKAGE"
    done
}

NPM_PACKAGES=(
    "eslint"
    "fkill"
    "jsonlint"
    "markdownlint-cli"
    "puppeteer"
    "speed-test"
    "standard"
    "tldr"
)
