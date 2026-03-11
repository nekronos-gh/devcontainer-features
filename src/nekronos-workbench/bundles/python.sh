#!/usr/bin/env bash
set -euo pipefail

# Install python dependencies
if command -v apt-get &>/dev/null; then
	apt-get update -y
	apt-get install -y python3 python3-pip python3-venv python3-dev nodejs npm
elif command -v dnf &>/dev/null; then
	dnf install -y python3 python3-pip python3-devel nodejs npm
elif command -v yum &>/dev/null; then
	yum install -y python3 python3-pip python3-devel nodejs npm
elif command -v pacman &>/dev/null; then
	pacman -Sy --noconfirm python python-pip nodejs npm
elif command -v apk &>/dev/null; then
	apk add --no-cache python3 py3-pip python3-dev gcc musl-dev nodejs npm
elif command -v zypper &>/dev/null; then
	zypper install -y python3 python3-pip python3-devel nodejs npm
elif command -v brew &>/dev/null; then
	brew install python3 node
else
	echo "Could not find a sutiable package manager"
	return 1
fi

# Install pyright, ruff, debugpy via Mason into Neovim
run_as_user "nvim --headless '+MasonInstall pyright ruff debugpy' -c 'qa'" || true
