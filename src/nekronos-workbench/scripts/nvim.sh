install_nvim() {
	if have nvim; then
		echo "Neovim already installed"
		return
	fi

	local arch
	arch="$(detect_architecture)"
	local nvim_arch
	if [ "$arch" = "x86_64" ]; then
		nvim_arch="x86_64"
	elif [ "$arch" = "aarch64" ]; then
		nvim_arch="arm64"
	fi

	local nvim_url="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-${nvim_arch}.tar.gz"

	echo "Installing Neovim from $nvim_url..."
	curl -fsSL "$nvim_url" -o /tmp/nvim.tar.gz
	tar -xzf /tmp/nvim.tar.gz -C /usr/local --strip-components=1
	rm -f /tmp/nvim.tar.gz
}

configure_nvim() {
	local repo="https://github.com/nekronos-gh/nvim"
	local branch="main"

	mkdir -p "$TARGET_HOME/.config"

	if [ ! -d "$TARGET_HOME/.config/nvim/.git" ]; then
		git clone --depth 1 --branch "$branch" "$repo" "$TARGET_HOME/.config/nvim"
	fi

	run_as_user "nvim --headless '+Lazy! sync' +qa" || true
}
