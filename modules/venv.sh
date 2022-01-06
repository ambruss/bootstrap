#!/usr/bin/env bash

is_installed() {
    test -d "$VENV" || return 1
    OLD=$("$VENV/bin/pip" freeze | sed 's|([^=]+)=.*|\1|' | tr '[:upper:]' '[:lower:]' | sort)
    NEW=$(comm -23 <(printf "%s\n" "${VENV_PACKAGES[@]}" | sed 's|\[.*||' | sort) <(echo "$OLD"))
    test -z "$NEW" || return 1
}

install() {
    ! $FORCE || rm -rf "$VENV"
    PY_BIN=$(command -v python3)
    test -d "$VENV" || "$PY_BIN" -m venv "$VENV"
    "$VENV/bin/pip" install -U pip setuptools wheel
    "$VENV/bin/pip" install -U "${VENV_PACKAGES[@]}"
    "$VENV/bin/ipython" profile create
    sed_ipy() { sed -i "s|^# ?$1.*|$1 = $2|" ~/.ipython/profile_default/ipython_config.py; }
    sed_ipy c.InteractiveShellApp.extensions "['autoreload']"
    sed_ipy c.InteractiveShellApp.exec_lines "['%autoreload 2']"
    sed_ipy c.TerminalIPythonApp.display_banner False
    sed_ipy c.TerminalInteractiveShell.confirm_exit False
    sed_ipy c.TerminalInteractiveShell.editor "'micro'"
    sed_ipy c.TerminalInteractiveShell.term_title_format "'ipy {cwd}'"
    sed_ipy c.Completer.greedy True
    poetry config virtualenvs.in-project true
}

VENV_PACKAGES=(
    "ansible"
    "apscheduler"
    "asciinema"
    "awscli"
    "bokeh"
    "bs4"
    "docker"
    "docker-compose"
    "httpie"
    "icdiff"
    "invoke"
    "ipython"
    "numpy"
    "pandas"
    "pandoc"
    "pipenv"
    "poetry"
    "pre-commit"
    "psutil"
    "pyyaml"
    "requests"
    "requests-html"
    "seaborn"
    "sh"
    "yappi"
    "yq"
)

! $ALL || VENV_PACKAGES+=(
    "arrow"
    "black"
    "delorean"
    "dicomweb-client"
    "fastapi"
    "flake8"
    "flake8-bugbear"
    "fuzzywuzzy[speedup]"
    "isort"
    "jedi"
    "keras"
    "matplotlib"
    "mypy"
    "pendulum"
    "pillow"
    "pydicom"
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
)
