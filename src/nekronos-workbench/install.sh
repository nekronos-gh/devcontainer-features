#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/scripts/utils.sh"
source "$SCRIPT_DIR/scripts/zsh.sh"
source "$SCRIPT_DIR/scripts/nvim.sh"
source "$SCRIPT_DIR/scripts/opencode.sh"

configure_zsh
configure_opencode
configure_nvim

# Process bundles
if [ -n "${BUNDLES:-}" ]; then
	IFS=',' read -ra BUNDLE_ARRAY <<<"$BUNDLES"
	for bundle in "${BUNDLE_ARRAY[@]}"; do
		# Trim whitespace
		bundle=$(echo "$bundle" | xargs)
		if [ -z "$bundle" ]; then continue; fi
		bundle_script="$SCRIPT_DIR/bundles/${bundle}.sh"
		if [ -f "$bundle_script" ]; then
			echo "Installing bundle: $bundle"
			source "$bundle_script"
		else
			echo "Warning: Bundle '$bundle' not found at $bundle_script"
		fi
	done
fi

# Add final scripts
mkdir -p /usr/local/share/nekronos-workbench
cat <<EOF >/usr/local/share/nekronos-workbench/post_create.sh
#!/bin/bash
EOF
chmod +x /usr/local/share/nekronos-workbench/post_create.sh
