install_ripgrep() {
  if have rg; then
    echo "ripgrep already installed"
    return
  fi

  local arch
  arch="$(detect_architecture)"
  local rg_arch
  if [ "$arch" = "x86_64" ]; then
    rg_arch="x86_64-unknown-linux-musl"
  elif [ "$arch" = "aarch64" ]; then
    rg_arch="aarch64-unknown-linux-musl"
  fi

  local latest_url
  latest_url=$(curl -fsSL -I -o /dev/null -w "%{url_effective}" https://github.com/BurntSushi/ripgrep/releases/latest)
  local rg_version
  rg_version=$(basename "$latest_url" | sed 's/^v//')

  local tarball="ripgrep-${rg_version}-${rg_arch}.tar.gz"
  local url="https://github.com/BurntSushi/ripgrep/releases/download/${rg_version}/${tarball}"

  echo "Installing ripgrep from $url..."
  curl -fsSL "$url" -o /tmp/rg.tar.gz
  tar -xzf /tmp/rg.tar.gz -C /tmp
  mv "/tmp/ripgrep-${rg_version}-${rg_arch}/rg" /usr/local/bin/rg
  chmod +x /usr/local/bin/rg
  rm -rf /tmp/rg.tar.gz "/tmp/ripgrep-${rg_version}-${rg_arch}"
}

install_fzf() {
  if have fzf; then
    echo "fzf already installed"
    return
  fi

  local arch
  arch="$(detect_architecture)"
  local fzf_arch
  if [ "$arch" = "x86_64" ]; then
    fzf_arch="amd64"
  elif [ "$arch" = "aarch64" ]; then
    fzf_arch="arm64"
  fi

  local latest_url
  latest_url=$(curl -fsSL -I -o /dev/null -w "%{url_effective}" https://github.com/junegunn/fzf/releases/latest)
  local fzf_version
  fzf_version=$(basename "$latest_url" | sed 's/^v//')

  local tarball="fzf-${fzf_version}-linux_${fzf_arch}.tar.gz"
  local url="https://github.com/junegunn/fzf/releases/download/v${fzf_version}/${tarball}"

  echo "Installing fzf from $url..."
  curl -fsSL "$url" -o /tmp/fzf.tar.gz
  tar -xzf /tmp/fzf.tar.gz -C /usr/local/bin fzf
  chmod +x /usr/local/bin/fzf
  rm -f /tmp/fzf.tar.gz
}
