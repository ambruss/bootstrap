#!/usr/bin/env bash

is_installed() { cmd gcloud; }

install() {
    export CLOUDSDK_INSTALL_DIR=$PREFIX
    export CLOUDSDK_CORE_DISABLE_PROMPTS=1
    export CLOUDSDK_PYTHON=/usr/bin/python3.6
    rm -rf "$CLOUDSDK_INSTALL_DIR/google-cloud-sdk"
    curl https://sdk.cloud.google.com | bash
    ln -sf "$CLOUDSDK_INSTALL_DIR"/google-cloud-sdk/bin/* "$BIN"
}
