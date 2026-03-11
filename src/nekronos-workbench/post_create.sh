#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/scripts/utils.sh"

run_as_user "nvim --headless '+Lazy! sync' '+MasonUpdate' +qa || true"
# Install Neovim plugins again to ensure full setup
run_as_user "nvim --headless '+Lazy! sync' +qa || true"
