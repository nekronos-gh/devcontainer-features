#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/scripts/utils.sh"
source "$SCRIPT_DIR/scripts/zsh.sh"
source "$SCRIPT_DIR/scripts/nvim.sh"
source "$SCRIPT_DIR/scripts/opencode.sh"

configure_zsh
configure_nvim
configure_opencode

# Add final scripts
mkdir -p /usr/local/share/nekronos-workbench
cat <<EOF > /usr/local/share/nekronos-workbench/post_create.sh
#!/bin/bash
EOF
chmod +x /usr/local/share/nekronos-workbench/post_create.sh
