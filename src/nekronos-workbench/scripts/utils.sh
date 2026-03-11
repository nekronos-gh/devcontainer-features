#!/usr/bin/env bash

have() {
	command -v "$1" >/dev/null 2>&1
}

append_if_missing() {
	grep -qxF "$2" "$1" || echo "$2" >>"$1"
}

run_as_user() {
	local user="${_REMOTE_USER:-nekronos}"
	# if user doesn't exist, fallback to root
	if ! id "$user" >/dev/null 2>&1; then
		user="root"
	fi

	if [ "$(id -un)" = "$user" ]; then
		bash -lc "$1"
	else
		su "$user" -c "$1"
	fi
}

require_root() {
	if [ "$(id -u)" -ne 0 ]; then
		echo "This script must be run as root." >&2
		exit 1
	fi
}

detect_architecture() {
	local arch
	arch="$(uname -m)"
	case "${arch}" in
	x86_64 | amd64) echo "x86_64" ;;
	aarch64 | arm64) echo "aarch64" ;;
	*)
		echo "Unsupported architecture: ${arch}" >&2
		exit 1
		;;
	esac
}

detect_pkg_manager() {
	if have apt-get; then
		echo "apt"
	elif have dnf; then
		echo "dnf"
	elif have yum; then
		echo "yum"
	elif have apk; then
		echo "apk"
	elif have pacman; then
		echo "pacman"
	else
		echo "unknown"
	fi
}

install_packages() {
	local pkg_manager
	pkg_manager="$(detect_pkg_manager)"

	if [ "$pkg_manager" = "unknown" ]; then
		echo "Could not detect package manager." >&2
		exit 1
	fi

	if [ -z "${PKG_UPDATED:-}" ]; then
		case "$pkg_manager" in
		apt) apt-get update -y ;;
		dnf) dnf check-update || true ;;
		yum) yum check-update || true ;;
		apk) apk update ;;
		pacman) pacman -Sy --noconfirm ;;
		esac
		export PKG_UPDATED=1
	fi

	case "$pkg_manager" in
	apt) DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "$@" ;;
	dnf) dnf install -y "$@" ;;
	yum) yum install -y "$@" ;;
	apk) apk add --no-cache "$@" ;;
	pacman) pacman -S --noconfirm "$@" ;;
	esac
}

ensure_tool() {
	local tool="$1"
	shift
	if ! have "$tool"; then
		echo "Tool '$tool' not found. Installing..."
		if [ $# -eq 0 ]; then
			install_packages "$tool"
		else
			install_packages "$@"
		fi
	fi
}
