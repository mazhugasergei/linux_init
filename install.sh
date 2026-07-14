#!/bin/bash
set -e


running_as_root || { echo "Run this script as root (or via su -c)."; exit 1; }


# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UTILS_DIR="$SCRIPT_DIR/_/zsh/utils"
source "$UTILS_DIR/shell.sh"
source "$UTILS_DIR/source.sh"
source "$UTILS_DIR/config.sh"

# Confirm prompts
confirm "Install desktop apps (GNOME + Brave)?" && INSTALL_DESKTOP="y" || INSTALL_DESKTOP="n"

apt update
apt install -y sudo git curl btop fastfetch
setup_fastfetch

setup_sudoers "$(get_real_user)"

# Install desktop apps if requested
if [[ "$INSTALL_DESKTOP" == "y" ]]; then
  apt install -y --no-install-recommends \
    gnome-session gnome-shell gdm3 gvfs gvfs-backends \
    network-manager-gnome nautilus gnome-terminal gnome-tweaks \
    gnome-text-editor gnome-system-monitor xdg-desktop-portal-gnome \
    fonts-cantarell

  curl -fsS https://dl.brave.com/install.sh | sh
else
  echo "Skipping desktop install."
fi

echo "Done."
