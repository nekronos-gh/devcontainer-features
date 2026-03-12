#!/usr/bin/env bash
set -euo pipefail

command -v pdflatex
command -v latexmk
command -v biber
command -v chktex

declare -a tools=("texlab" "latexindent")

for tool in "${tools[@]}"; do
	local_bin="/home/${_REMOTE_USER:-vscode}/.local/share/nvim/mason/bin/$tool"
	if [ -f "$local_bin" ]; then
		echo "✓ mason: $tool"
	else
		echo "✗ mason: $tool not found"
		exit 1
	fi
done

echo "LaTeX bundle installed correctly"
