#!/usr/bin/env bash

is_installed() { cmd k3d; }

install() {
    curl https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
}
