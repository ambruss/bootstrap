#!/usr/bin/env bash

OPTIONAL=true

is_installed() { cmd code; }

install() {
    URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    curl -o vscode.deb "$URL"
    sudo dpkg --install vscode.deb
    for EXT in "${EXTENSIONS[@]}"; do
        code --install-extension "$EXT"
    done
}

EXTENSIONS=(
    Atishay-Jain.All-Autocomplete
    christian-kohler.path-intellisense
    eamodio.gitlens
    ecmel.vscode-html-css
    Gruntfuggly.todo-tree
    ms-azuretools.vscode-docker
    ms-kubernetes-tools.vscode-kubernetes-tools
    ms-python.python
    ms-python.vscode-pylance
    redhat.vscode-yaml
    Tim-Koehler.helm-intellisense
    Tyriar.sort-lines
    yzhang.markdown-all-in-one
)
