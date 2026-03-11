#!/usr/bin/env bash
set -euo pipefail

# Install dependencies
pkg_manager="$(detect_pkg_manager)"
case "$pkg_manager" in
apt) install_packages python3 python3-pip python3-venv python3-dev nodejs npm ;;
dnf | yum) install_packages python3 python3-pip python3-devel nodejs npm ;;
apk) install_packages python3 py3-pip python3-dev gcc musl-dev nodejs npm ;;
pacman) install_packages python python-pip nodejs npm ;;
esac

# Install pyright, ruff, debugpy via Mason into Neovim
run_as_user "nvim --headless '+MasonInstall pyright ruff debugpy' -c 'qa'" || true
