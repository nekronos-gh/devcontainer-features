have() {
  command -v "$1" >/dev/null 2>&1
}

append_if_missing() {
  grep -qxF "$2" "$1" || echo "$2" >>"$1"
}

run_as_user() {
  local user="${_REMOTE_USER:-nekronos}"

  if [ "$(id -un)" = "$user" ]; then
    bash -lc "$1"
  else
    su "$user" -c "$1"
  fi
}
