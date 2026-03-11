configure_nvim() {
  local user="${_REMOTE_USER:-nekronos}"
  local home="/home/$user"

  local repo="https://github.com/nekronos-gh/nvim"
  local branch="main"

  mkdir -p "$home/.config"

  if [ ! -d "$home/.config/nvim/.git" ]; then
    run_as_user "git clone --depth 1 --branch '$branch' '$repo' '$home/.config/nvim'"
  fi

  run_as_user "nvim --headless '+Lazy! sync' +qa" || true
}
