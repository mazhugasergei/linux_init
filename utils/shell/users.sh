# Check if the script is running as root
# Returns 0 if yes, 1 otherwise
is_running_as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    return 0
  else
    return 1 
  fi
}

# Get the real user who invoked the script, even if run with sudo or pkexec
get_real_user() {
  if [ -n "${SUDO_USER:-}" ]; then
    echo "$SUDO_USER"
  elif command -v logname &>/dev/null && logname 2>/dev/null; then
    return
  elif [ -n "${PKEXEC_UID:-}" ]; then
    id -un "$PKEXEC_UID"
  elif [ -n "${ORIGINAL_USER:-}" ]; then
    echo "$ORIGINAL_USER"
  else
    echo "${USER:-$(whoami)}"
  fi
}

# Setup sudoers for the target user if not root
setup_sudoers() {
  local users=("$@")  # Accept all arguments as array

  # If no arguments provided, use current user
  if [ ${#users[@]} -eq 0 ]; then
    users=("$USER")
  fi

  logger info "Setting up sudoers"

  for user in "${users[@]}"; do
    if [ -z "$user" ] || [ "$user" = "root" ]; then
      echo "Skipping root or empty username."
      continue
    fi

    echo "Setting up passwordless sudo for user: $user"

    cat > "/etc/sudoers.d/99-${user}-nopasswd" << EOF
$user ALL=(ALL) NOPASSWD:ALL
EOF

    chmod 0440 "/etc/sudoers.d/99-${user}-nopasswd"
    /usr/sbin/visudo -cf "/etc/sudoers.d/99-${user}-nopasswd" || {
      echo "Error: Failed to validate sudoers file for $user"
      rm -f "/etc/sudoers.d/99-${user}-nopasswd"
      return 1
    }
  done

  echo "Sudoers setup completed for: ${users[*]}"
}
