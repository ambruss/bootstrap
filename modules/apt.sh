#!/usr/bin/env bash

is_installed() {
    OLD=$(apt list --installed 2>/dev/null | sed 's|([^/]+)/.*|\1|' | sort)
    NEW=$(comm -23 <(printf "%s\n" "${APT_PACKAGES[@]}" | sort) <(echo "$OLD"))
    test -z "$NEW" || return 1
}

install() {
    if ! cmd apt-add-repository; then
        sudo apt-get update -qqy
        sudo apt-get install -qqy software-properties-common
    fi
    sudo add-apt-repository -nsy ppa:deluge-team/stable
    sudo apt-add-repository -nsy ppa:philip.scott/pantheon-tweaks
    sudo apt-add-repository -nsy ppa:yunnxx/elementary
    sudo apt-get update -qqy
    sudo apt-get upgrade -qqy
    sudo apt-get install -qqy "${APT_PACKAGES[@]}"
    sudo apt-get autoremove -qqy
    sudo sh -c "printf '[User]\nSystemAccount=true\n' >/var/lib/AccountsService/users/libvirt-qemu"
    sudo rm -f /etc/xdg/autostart/nm-applet.desktop
    sudo sed -i "s/GNOME;\$/GNOME;Pantheon;/" /etc/xdg/autostart/indicator-application.desktop
    sudo systemctl restart accounts-daemon.service
}

APT_PACKAGES=(
    apt-file
    apt-transport-https
    autoconf
    automake
    bridge-utils
    build-essential
    cifs-utils
    cmake
    curl
    deluge
    deluged
    deluge-console
    deluge-web
    dh-autoreconf
    dkms
    dmg2img
    docbook-xsl-ns
    dstat
    gfortran
    gimp
    git
    gparted
    htop
    indicator-application
    kazam
    libblas-dev
    libbz2-dev
    libguestfs-tools
    libhdf5-103
    libhdf5-dev
    liblapack-dev
    libncurses5-dev
    libncursesw5-dev
    libreadline-dev
    librsvg2-bin
    libsqlite3-dev
    libssl-dev
    libtool
    libvirt-dev
    linux-headers-"$(uname -r)"
    llvm
    meld
    moreutils
    nano
    ncdu
    octave
    openssh-server
    pantheon-tweaks
    pkg-config
    python3-dev
    python3-venv
    qemu
    qemu-kvm
    samba
    samba-common
    software-properties-common
    swig
    texlive-xetex
    tig
    tmux
    tree
    ttf-dejavu-extra
    uml-utilities
    virt-manager
    virt-top
    virtinst
    wget
    wingpanel-indicator-ayatana
    xclip
    xsel
    xsltproc
    xz-utils
    zip
    zlib1g-dev
    zsh
)
