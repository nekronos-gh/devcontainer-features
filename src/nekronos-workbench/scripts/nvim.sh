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
	local user="${_REMOTE_USER:-nekronos}"
	local home="/home/$user"

	# if user doesn't exist, we fallback to root
	if ! id "$user" >/dev/null 2>&1; then
		user="root"
		home="/root"
	fi

	local repo="https://github.com/nekronos-gh/nvim"
	local branch="main"

	run_as_user "mkdir -p '$home/.config'"

	if [ ! -d "$home/.config/nvim/.git" ]; then
		run_as_user "git clone --depth 1 --branch '$branch' '$repo' '$home/.config/nvim'"
	fi

	run_as_user "nvim --headless '+Lazy! sync' +qa" || true
}
