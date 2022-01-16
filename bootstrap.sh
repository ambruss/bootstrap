#!/usr/bin/env bash
set -euo pipefail
USAGE="Usage: $0 [OPTION...]

Automated development environment setup for Elementary OS 6.1.

Examples:
  $0 --include jq=1.6
  $0 --exclude go

Options:
  -l, --list                List available modules
  -a, --all                 Include all optional modules
  -i, --include MOD[=VER]   Only install explicitly included modules
                            Optionally define module version to install
  -x, --exclude MOD         Skip installing explicitly excluded modules
  -f, --force               Force reinstalls even if module is already present
      --skip-to MOD         Only install modules after the given MOD
      --dry-run             Only print what would be installed
      --debug               Show command tracing messages

"

# constants / defaults
DIR="$(cd "$(dirname "$0")" && pwd)"
VRE="[0-9]+(\.[0-9]+)+"

LIST=false
ALL=false
INCLUDE=()
EXCLUDE=()
INSTALL=()
FORCE=false
SKIPTO=
DRYRUN=false
DEBUG=false
SUDO=false

CONFIG=$HOME/.config
PREFIX=$HOME/.local
VENV=$HOME/.venv
BIN=$PREFIX/bin
LIB=$PREFIX/lib
GO=$PREFIX/go

# logging helpers
CRED=$(tput setaf 1)
CGREEN=$(tput setaf 2)
CRESET=$(tput sgr0)
_log() { printf "%b${EOL:-\n}" "$*" >&2; }
log() { _log "[${CGREEN}INFO${CRESET}]" "$@"; }
err() { _log "[${CRED}ERROR${CRESET}]" "$@"; }
die() { err "$@"; exit "${EXIT_CODE:-1}"; }
quiet() { "$@" >/dev/null 2>&1; }

# basic shorthands
cmd() { quiet command -v "$1"; }
cd() { mkdir -p "$1"; command cd "$1" || die "Cannot cd into $1"; }
CACHE=/tmp/cache && mkdir -p "$CACHE"
curl() {
    CACHE_MD5=$CACHE/$(echo "$*" | md5sum | cut -d' ' -f1)
    test -f "$CACHE_MD5" && { cat "$CACHE_MD5"; return; }
    log "curl $*"
    env curl -fLSs --retry 2 --connect-timeout 5 "$@" | tee "$CACHE_MD5"
}
sudo() {  # maintain sudo after 1st prompt
    if ! $SUDO; then
        env sudo true
        SUDO=true
        while true; do
            sleep 60 && env sudo -n true
        done &
    fi
    env sudo "$@"
}

main() {
    # parse arguments
    while test $# -gt 0; do
    case $1 in
        -h|--help)      echo "$USAGE"; exit;;
        -l|--list)      LIST=true;;
        -a|--all)       ALL=true;;
        -i|--include)   INCLUDE+=("$2"); shift;;
        -x|--exclude)   EXCLUDE+=("$2"); shift;;
        -f|--force)     FORCE=true;;
        --skip-to)      SKIPTO="$2"; shift;;
        --dry-run)      DRYRUN=true;;
        --debug)        DEBUG=true;;
        *)              die "Invalid argument: $1\n\n$USAGE";;
    esac && shift
    done
    ! $DEBUG || set -x
    # clone the bootstrap repo 1st to access the modules
    export DEBIAN_FRONTEND=noninteractive
    if ! test -d "$DIR/modules"; then
        DIR=$PREFIX/bootstrap
        if [ ! -d "$DIR" ]; then
            log "Cloning ambruss/bootstrap"
            cmd git || sudo apt-get install -qqy git
            gh_clone ambruss/bootstrap "$DIR"
        fi
    fi
    # validate modules passed via include/exclude arguments
    # shellcheck disable=SC2207
    MODULES=($(find "$DIR/modules" -type f | sed -E 's|.*/(.*)\.sh|\1|' | sort))
    for SPEC in "${INCLUDE[@]}" "${EXCLUDE[@]}"; do
        MOD=${SPEC%=*}  # strip any version override in include specs
        echo " ${MODULES[*]} " | grep -Pq " $MOD " || die "Invalid module $MOD"
    done
    # exclude the optional mods unless using --all
    $ALL || for MOD in "${MODULES[@]}"; do
        # shellcheck disable=SC2206
        ! grep -q OPTIONAL "$DIR/modules/$MOD.sh" || MODULES=(${MODULES[@]//$MOD*})
    done
    # print a list and exit on --list
    ! $LIST || { echo "${MODULES[@]}" | tr ' ' '\n'; exit; }
    # apply include/exclude filters and skipto
    INSTALL=("${MODULES[@]}")
    test -z "${INCLUDE[*]}" || INSTALL=("${INCLUDE[@]}")
    test -z "${EXCLUDE[*]}" || for MOD in "${EXCLUDE[@]}"; do
        # shellcheck disable=SC2206
        INSTALL=(${INSTALL[@]//$MOD*})
    done
    while [ -n "$SKIPTO" ]; do
        test "${INSTALL[0]}" \< "$SKIPTO" && INSTALL=("${INSTALL[@]:1}") || SKIPTO=
    done
    # define and create dirs, extend path
    mkdir -p "$CACHE" "$CONFIG" "$BIN" "$LIB"
    BINS=$BIN:$VENV/bin:$GO/bin
    echo "$PATH" | grep -q "$BINS" || PATH=$BINS:$PATH
    export PATH
    # install selected modules
    on_start
    for SPEC in "${INSTALL[@]}"; do
        ! grep -Pq "sudo" "$DIR/modules/${SPEC%=*}.sh" || { sudo true; break; }
    done
    for SPEC in "${INSTALL[@]}"; do
        install_module "$SPEC"
    done
}

on_start() {  # create and use tempdir and register exit hook
    TMP=$(mktemp --directory --suffix .$$)
    cd "$TMP"
    trap on_exit EXIT
}

on_exit() {  # clean up tempdir, log exit status and kill the sudo loop
    CODE=$?
    rm -rf "$TMP"
    if [ "$CODE" = 0 ]; then
        log "$(basename "$0") finished"
    else
        err "$(basename "$0") exited with $CODE"
        $DEBUG || err "Re-run with --debug for trace"
    fi
    kill 0
}

install_module() {(  # install ./modules entry
    MOD=${1%=*}
    VER=${1:${#MOD}+1}
    # shellcheck disable=SC1090
    . "$DIR/modules/$MOD.sh"
    if $FORCE || ! is_installed; then
        log "Installing $MOD (${VER:-latest})"
        $DRYRUN || install
    else
        log "Skipping $MOD (already installed)"
    fi
)}

sortver() { grep -Pv "alpha|beta|dev|rc" | sort -rV | uniq; }
latest() { sortver | head -n1; }
semver() { echo "${1:-$(cat)}" | grep -Po "$VRE"; }
web_asset() { curl "$1" | grep -Po "${2:=$VRE}" | sed -E "s|.*($2).*|\1|" | latest; }
gh_clone() { git clone --depth 1 "https://github.com/$1.git" "${@:2}"; }
gh_tags() { gh_vers "$@" tags; }
gh_rels() { gh_vers "$@" releases; }
gh_ver() { gh_vers "$@" | head -n1; }
gh_vers() {
    curl "https://github.com/$1/${2:-tags}" \
        | grep -Po "tags/.*${VER:-$VRE}.*.tar.gz" \
        | sed -E "s|tags/(.*).tar.gz|\1|" \
        | sortver
}
gh_asset() {
    test -n "${VER:-}" || VER=$(gh_rels "$1" | head -n1)
    test -n "${VER:-}" || die "Cannot find latest version for $1"
    ASSET=$(curl "https://github.com/$1/releases" | grep -Po "download/$VER/$2" | head -n1)
    test -n "$ASSET" || die "Cannot find asset $VER/$2 for $1"
    echo "https://github.com/$1/releases/$ASSET"
}
gh_tar() {
    test -n "${VER:-}" || VER=$(gh_tags "$1" | head -n1)
    test -n "${VER:-}" || die "Cannot find latest version for $1"
    TAR=$(curl "https://github.com/$1/tags" | grep -Po "archive/refs/tags/$VER.tar.gz" | head -n1)
    test -n "$TAR" || die "Cannot find $VER.tar.gz for $1"
    echo "https://github.com/$1/$TAR"
}

main "$@"
