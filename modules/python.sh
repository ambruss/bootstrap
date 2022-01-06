#!/usr/bin/env bash

OPTIONAL=true

is_installed() {
    PY_VER=$(python_ver)
    PY_BIN=$(echo "python$PY_VER" | sed -E 's/\.[0-9]$//')
    cmd "$PY_BIN"
}

install() {
    PY_VER=$(python_ver)
    curl "https://www.python.org/ftp/python/$PY_VER/Python-$PY_VER.tar.xz" | tar xJ
    cd Python-*
    ./configure \
        --enable-optimizations \
        --enable-shared \
        --prefix="$PREFIX" \
        --with-ensurepip=install \
        LDFLAGS="-Wl,-rpath $PREFIX/lib"
    make "-j$(nproc)"
    make altinstall
    rm -rf ../Python-*
}

python_ver() {
    test -z "${VER:-}" && VER=$VRE || VER="$VER(\.[0-9]+)*"
    web_asset https://www.python.org/downloads/ ">Python $VER<" | semver
}
