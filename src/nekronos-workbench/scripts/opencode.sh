configure_opencode() {
  local user="${_REMOTE_USER:-nekronos}"
  local home="/home/$user"
  local zshrc="$home/.zshrc"

  run_as_user "curl -fsSL https://opencode.ai/install | bash"
  append_if_missing "$zshrc" 'export PATH="$HOME/.opencode/bin:$PATH"'
}
