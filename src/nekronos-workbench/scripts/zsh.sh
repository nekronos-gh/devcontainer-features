install_oh_my_zsh() {
	if [ ! -d "$TARGET_HOME/.oh-my-zsh" ]; then
		run_as_user "curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s -- --unattended"
	fi

	# Set default shell to zsh for the user
	if have zsh; then
		local zsh_path
		zsh_path="$(command -v zsh)"
		if have chsh; then
			chsh -s "$zsh_path" "$TARGET_USER" || true
		else
			# Fallback for systems without chsh (like Alpine)
			if grep -q "^${user}:" /etc/passwd; then
				sed -i -e "/^${user}:/ s|:[^:]*$|:${zsh_path}|" /etc/passwd || true
			fi
		fi
	fi
}

configure_zsh() {
	local ZSHRC="$TARGET_HOME/.zshrc"
	local plugin_dir="$TARGET_HOME/.oh-my-zsh/custom/plugins"

	run_as_user "mkdir -p '$plugin_dir'"

	if [ ! -d "$plugin_dir/zsh-autosuggestions/.git" ]; then
		run_as_user "git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions '$plugin_dir/zsh-autosuggestions'"
	fi

	if [ ! -d "$plugin_dir/zsh-syntax-highlighting/.git" ]; then
		run_as_user "git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting '$plugin_dir/zsh-syntax-highlighting'"
	fi

	run_as_user "touch '$ZSHRC'"
	append_if_missing "$ZSHRC" 'plugins=(git docker python zsh-autosuggestions zsh-syntax-highlighting)'
}
