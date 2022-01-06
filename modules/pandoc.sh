#!/usr/bin/env bash

OPTIONAL=true

is_installed() { cmd pandoc; }

install() {
    URL=$(gh_asset jgm/pandoc "pandoc-.*-amd64.deb")
    curl -O "$URL"
    sudo dpkg --install pandoc-*.deb || sudo apt-get install -fqqy
    # TODO first-run
}
