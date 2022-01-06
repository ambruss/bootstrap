#!/usr/bin/env bash

OPTIONAL=true

is_installed() { cmd gdcmdump; }

install() {
    URL="$(gh_tar malaterre/GDCM)"
    curl "$URL" | tar xz
    cd GDCM-*
    cmake \
        -DGDCM_BUILD_APPLICATIONS=1 \
        -DGDCM_BUILD_SHARED_LIBS=1 \
        -DGDCM_WRAP_PYTHON=1 \
        .
    make "-j$(nproc)"
    sudo make install
    sudo ldconfig
    cp -r /usr/local/lib/*gdcm* "$VENV"/lib/python*/site-packages
}
