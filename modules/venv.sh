#!/usr/bin/env bash

is_installed() {
    test -d "$VENV" || return 1
    OLD=$("$VENV/bin/pip" freeze | sed 's|([^=]+)=.*|\1|' | tr '[:upper:]' '[:lower:]' | sort)
    NEW=$(comm -23 <(printf "%s\n" "${VENV_PACKAGES[@]}" | sed 's|\[.*||' | sort) <(echo "$OLD"))
    test -z "$NEW" || return 1
}

install() {
    ! $FORCE || rm -rf "$VENV"
    if [ "$SETUP" = dev ]; then
        PY_BIN=$(find /usr/bin -name 'python*' | grep -v config | sort -V | tail -n1)
    else
        PY_BIN=$(command -v python3)
    fi
    test -d "$VENV" || "$PY_BIN" -m venv "$VENV"
    "$VENV/bin/pip" install -U pip setuptools wheel
    "$VENV/bin/pip" install -U "${VENV_PACKAGES[@]}"
    configure
}

configure() {
    "$VENV/bin/ipython" profile create
    sed_ipy() { sed -i "s|^# ?$1.*|$1 = $2|" ~/.ipython/profile_default/ipython_config.py; }
    sed_ipy c.InteractiveShellApp.extensions "['autoreload']"
    sed_ipy c.InteractiveShellApp.exec_lines "['%autoreload 2']"
    sed_ipy c.TerminalIPythonApp.display_banner False
    sed_ipy c.TerminalInteractiveShell.confirm_exit False
    sed_ipy c.TerminalInteractiveShell.editor "'nano'"
    sed_ipy c.TerminalInteractiveShell.term_title_format "'ipy {cwd}'"
    sed_ipy c.Completer.greedy True
}

VENV_PACKAGES=(
    "bs4"
    "docker-compose"
    "fuzzywuzzy[speedup]"
    "httpie"
    "icdiff"
    "invoke"
    "ipython"
    "pillow"
    "psutil"
    "pyyaml"
    "requests"
    "requests-html"
    "scrapy"
    "sh"
    "yq"
)

VENV_PACKAGES_DEV=(
    "ansible"
    "apscheduler"
    "arrow"
    "asciinema"
    "awscli"
    "black"
    "bokeh"
    "delorean"
    "dicomweb-client"
    "fastapi"
    "flake8"
    "flake8-bugbear"
    "isort"
    "jedi"
    "keras"
    "matplotlib"
    "mypy"
    "numpy"
    "pandas"
    "pandoc"
    "pendulum"
    "pipenv"
    "poetry"
    "pre-commit"
    "pydicom"
    "pyjq"
    "pylint"
    "pynetdicom"
    "pyqt5"
    "pytest"
    "pytest-cov"
    "pytest-faker"
    "pytest-mock"
    "pytest-testmon"
    "pytest-watch"
    "python-dateutil"
    "pytimeparse"
    "pytz"
    "scikit-learn"
    "scipy"
    "sqlalchemy"
    "typer[all]"
    "yamllint"
    "yappi"
)

if [ "$SETUP" = dev ]; then
    VENV_PACKAGES+=("${VENV_PACKAGES_DEV[@]}")
fi
