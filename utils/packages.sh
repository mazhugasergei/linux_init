install_must_have_packages() {
  logger info "Installing must-have packages..."
  apt install -y "${must_have_packages[@]}"
}

install_desktop_packages() {
  if [[ "$INSTALL_DESKTOP" == "y" ]]; then
    logger info "Installing desktop packages..."
    
    apt install -y --no-install-recommends \
      gnome-session gnome-shell gdm3 gvfs gvfs-backends \
      network-manager-gnome nautilus gnome-terminal gnome-tweaks \
      gnome-text-editor gnome-system-monitor xdg-desktop-portal-gnome \
      fonts-cantarell

    curl -fsS https://dl.brave.com/install.sh | sh
  else
    logger info "Skipping desktop install."
  fi
}
