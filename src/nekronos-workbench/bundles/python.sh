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

run_as_user "install -m 0644 '$SCRIPT_DIR/bundles/python.lua' '$TARGET_HOME/.config/nvim/lua/bundles/python.lua'"
run_as_user "nvim --headless '+MasonToolsInstallSync' -c 'qa'"
