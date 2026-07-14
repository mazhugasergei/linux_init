# Check if the script is running as root
running_as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    return 0
  else
    return 1 
  fi
}

# Get the real user who invoked the script, even if run with sudo or pkexec
get_real_user() {
  # Priority order (best to worst)
  if [ -n "${SUDO_USER:-}" ]; then
    echo "$SUDO_USER"
  elif [ -n "${PKEXEC_UID:-}" ]; then
    id -un "$PKEXEC_UID"
  elif [ -n "${ORIGINAL_USER:-}" ]; then
    echo "$ORIGINAL_USER"
  else
    # Fallback
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

# Logger object with dot notation methods
# Usage: logger <method> <message>
# Methods: info, done, error, warn
logger() {
	local method="$1"
	local message="$2"
	
	case "$method" in
		"info")
			echo -e "\033[44m INFO \033[0m $message"
			;;
		"done")
			echo -e "\033[42m DONE \033[0m $message"
			;;
		"error")
			echo -e "\033[41m ERROR \033[0m $message"
			;;
		"warn")
			echo -e "\033[43m WARN \033[0m $message"
			;;
		*)
			echo "Unknown logger method: $method"
			return 1
			;;
	esac
}

# Display a prompt and get a yes/no answer from the user.
# Usage: confirm "Prompt message" | confirm "Prompt message" "Y" | confirm "Prompt message" "N"
# Returns: 0 for yes, 1 for no
confirm() {
  local prompt="$1"
  local default="${2:-}"  # Optional: "Y" or "N"
  local answer

  while true; do
    if [ "$default" = "Y" ] || [ "$default" = "y" ]; then
      read -rp "$prompt [Y/n]: " answer
    elif [ "$default" = "N" ] || [ "$default" = "n" ]; then
      read -rp "$prompt [y/N]: " answer
    else
      read -rp "$prompt [y/n]: " answer
    fi

    answer="${answer,,}"  # to lowercase

    case "$answer" in
      y|yes) return 0 ;;
      n|no)  return 1 ;;
      "") 
        # Enter pressed - use default if set
        if [ "$default" = "Y" ] || [ "$default" = "y" ]; then
          return 0
        elif [ "$default" = "N" ] || [ "$default" = "n" ]; then
          return 1
        else
          echo "Please answer y or n."
        fi
        ;;
      *) echo "Please answer y or n." ;;
    esac
  done
}
