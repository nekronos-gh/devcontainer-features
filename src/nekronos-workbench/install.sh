#!/bin/sh
set -e

# Bootstrap bash if missing, so the rest of the script can safely rely on bash
if ! command -v bash >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y && apt-get install -y --no-install-recommends bash
  elif command -v apk >/dev/null 2>&1; then
    apk update && apk add --no-cache bash
  elif command -v dnf >/dev/null 2>&1; then
    dnf install -y bash
  elif command -v yum >/dev/null 2>&1; then
    yum install -y bash
  elif command -v pacman >/dev/null 2>&1; then
    pacman -Sy --noconfirm bash
  else
    echo "Could not detect package manager to install bash" >&2
    exit 1
  fi
fi

if [ -z "${_REEXEC_BASH:-}" ]; then
  export _REEXEC_BASH=1
  exec bash "$0" "$@"
fi

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/scripts/utils.sh"
source "$SCRIPT_DIR/scripts/bin_utils.sh"
source "$SCRIPT_DIR/scripts/zsh.sh"
source "$SCRIPT_DIR/scripts/nvim.sh"
source "$SCRIPT_DIR/scripts/opencode.sh"

require_root

# Base prerequisites
pkg_manager="$(detect_pkg_manager)"
case "$pkg_manager" in
apt) install_packages ca-certificates curl tar gzip ;;
dnf | yum) install_packages ca-certificates curl tar gzip ;;
apk) install_packages ca-certificates curl tar gzip ;;
pacman) install_packages ca-certificates curl tar gzip ;;
esac

# Base tools for a developer
case "$pkg_manager" in
apt) install_packages git zsh gcc build-essential jq sudo ;;
dnf | yum) install_packages git zsh gcc make jq util-linux-user sudo ;;
apk) install_packages git zsh gcc build-base jq shadow sudo bash ;;
pacman) install_packages git zsh gcc base-devel jq sudo ;;
esac

# Install binary tools
install_ripgrep
install_fzf
install_nvim

# Configure tools
install_oh_my_zsh
configure_zsh
configure_opencode
configure_nvim

# Process bundles
if [ -n "${BUNDLES:-}" ]; then
	IFS=',' read -ra BUNDLE_ARRAY <<<"$BUNDLES"
	for bundle in "${BUNDLE_ARRAY[@]}"; do
		# Trim whitespace
		bundle="${bundle#"${bundle%%[![:space:]]*}"}"
		bundle="${bundle%"${bundle##*[![:space:]]}"}"
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