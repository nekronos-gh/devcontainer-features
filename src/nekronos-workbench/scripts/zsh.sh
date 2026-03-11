configure_zsh() {
  local user="${_REMOTE_USER:-nekronos}"
  local home="/home/$user"

  local ZSHRC="$home/.zshrc"
  local plugin_dir="$home/.oh-my-zsh/custom/plugins"

  mkdir -p "$plugin_dir"

  [ -d "$plugin_dir/zsh-autosuggestions/.git" ] ||
    run_as_user "git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions '$plugin_dir/zsh-autosuggestions'"

  [ -d "$plugin_dir/zsh-syntax-highlighting/.git" ] ||
    run_as_user "git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting '$plugin_dir/zsh-syntax-highlighting'"

  append_if_missing "$ZSHRC" 'plugins=(git docker python zsh-autosuggestions zsh-syntax-highlighting)'
}
