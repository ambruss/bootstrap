#!/usr/bin/env bash

OPTIONAL=true

is_installed() { cmd terraform; }

install() {
    VER=$(gh_ver hashicorp/terraform | semver)
    URL=https://releases.hashicorp.com/terraform/${VER}/terraform_${VER}_linux_amd64.zip
    curl -O "$URL"
    unzip terraform*.zip
    mv terraform "$BIN"
}
