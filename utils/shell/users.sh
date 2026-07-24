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

setup_sudoers() {
  local users=("$@")

  logger info "setting up passwordless sudo for users: ${BRIGHT_GRAY}${users[*]}${RESET}"

  # if no users are provided, default to the current user
  if [ ${#users[@]} -eq 0 ]; then
    users=("$USER")
  fi

  # Loop through each user and set up passwordless sudo
  for user in "${users[@]}"; do
    # skip if the user is empty
    if [ -z "$user" ]; then
      continue
    fi

    # skip if the user is root
    if [ "$user" = "root" ]; then
      logger info "skipping user: ${BRIGHT_GRAY}${user}${RESET}"
      continue
    fi

    # check if the user already has passwordless sudo
    local user_pattern="^[[:space:]]*${user}[[:space:]]+"
    local perm_pattern="ALL=\(ALL(:ALL)?\)[[:space:]]+"
    local nopasswd_pattern="NOPASSWD:[[:space:]]*ALL"
    local sudoers_regex="${user_pattern}${perm_pattern}${nopasswd_pattern}"

    if grep -rEq "$sudoers_regex" /etc/sudoers /etc/sudoers.d/ 2>/dev/null; then
      echo "alreadty has passwordless sudo: ${BRIGHT_GRAY}${user}${RESET}"
      continue
    fi

    # create a sudoers file for the user with passwordless sudo
    local sudoers_file="/etc/sudoers.d/99-${user}-nopasswd"

    cat > "$sudoers_file" << EOF
$user ALL=(ALL) NOPASSWD:ALL
EOF

    # lock down permissions, then validate before trusting the file;
    # roll back on failure so a bad file never lingers in sudoers.d
    chmod 0440 "$sudoers_file"
    /usr/sbin/visudo -cf "$sudoers_file" || {
      logger error "failed to validate sudoers file for $user"
      rm -f "$sudoers_file"
      return 1
    }

    logger info "passwordless sudo setup completed for user: ${BRIGHT_GRAY}${user}${RESET}"
  done
}
