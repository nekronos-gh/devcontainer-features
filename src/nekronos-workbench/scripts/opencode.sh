configure_opencode() {
	local user="${_REMOTE_USER:-nekronos}"
	local home="/home/$user"

	if ! id "$user" >/dev/null 2>&1; then
		user="root"
		home="/root"
	fi

	local zshrc="$home/.zshrc"

	run_as_user "curl -fsSL https://opencode.ai/install | bash"

	if [ -f "$zshrc" ]; then
		append_if_missing "$zshrc" 'export PATH="$HOME/.opencode/bin:$PATH"'
	else
		echo 'export PATH="$HOME/.opencode/bin:$PATH"' >>"$zshrc"
	fi
}
