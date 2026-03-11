configure_opencode() {
	local zshrc="$TARGET_HOME/.zshrc"

	run_as_user "curl -fsSL https://opencode.ai/install | bash"

	if [ -f "$zshrc" ]; then
		append_if_missing "$zshrc" 'export PATH="$HOME/.opencode/bin:$PATH"'
	else
		echo 'export PATH="$HOME/.opencode/bin:$PATH"' >>"$zshrc"
	fi
}
