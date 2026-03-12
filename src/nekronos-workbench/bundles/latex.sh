#!/usr/bin/env bash
set -euo pipefail

# Install dependencies for latex compilation and all useful latex libraries
pkg_manager="$(detect_pkg_manager)"
case "$pkg_manager" in
apt) install_packages texlive-full chktex latexmk biber nodejs npm ;;
dnf | yum) install_packages texlive-scheme-full chktex latexmk biber nodejs npm ;;
apk) install_packages texlive-full chktex latexmk biber nodejs npm ;;
pacman) install_packages texlive-meta chktex latexmk biber nodejs npm ;;
esac

run_as_user "install -m 0644 '$SCRIPT_DIR/bundles/latex.lua' '$TARGET_HOME/.config/nvim/lua/bundles/latex.lua'"
run_as_user "nvim --headless '+MasonToolsInstallSync' -c 'qa'"
