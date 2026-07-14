#!/bin/bash
set -e

TARGET_USER="$USER"

[ "$(id -u)" -eq 0 ] || { echo "Run this script as root (or via su -c)."; exit 1; }

# Loops until a valid y/n answer is given; returns 0 for yes, 1 for no
ask_yn() {
  local prompt="$1"
  local answer
  while true; do
    read -rp "$prompt [y/N]: " answer
    answer="${answer,,}"
    case "$answer" in
      y|yes) return 0 ;;
      n|no|"") return 1 ;;
      *) echo "Please answer y or n." ;;
    esac
  done
}

# Ask upfront, before touching the system
ask_yn "Install desktop apps (GNOME + Brave)?" && INSTALL_DESKTOP="y" || INSTALL_DESKTOP="n"

# --- Installation starts here ---

apt update
apt install -y sudo git curl

# Passwordless sudo for TARGET_USER
echo "${TARGET_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-${TARGET_USER}-nopasswd
chmod 0440 /etc/sudoers.d/99-${TARGET_USER}-nopasswd
visudo -cf /etc/sudoers.d/99-${TARGET_USER}-nopasswd

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