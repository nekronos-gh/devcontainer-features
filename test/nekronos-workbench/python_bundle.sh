#!/usr/bin/env bash
set -euo pipefail

command -v python3
command -v pip3

for tool in pyright-langserver ruff debugpy; do
	local_bin="/home/${_REMOTE_USER:-vscode}/.local/share/nvim/mason/bin/$tool"
	if [ -f "$local_bin" ]; then
		echo "✓ mason: $tool"
	else
		echo "✗ mason: $tool not found"
		return 1
	fi
done

echo "Python bundle installed correctly"
