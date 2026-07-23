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
