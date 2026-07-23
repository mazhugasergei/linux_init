install_packages() {
  logger info "Installing packages..."
  
  apt install -y "${packages[@]}"

  for package in "${!other_packages[@]}"; do
    local install_function="${other_packages[$package]}"
    if ! command -v "$package" &> /dev/null; then
      logger info "Installing $package..."
      $install_function || logger error "Failed to install $package"
    else
      logger done "$package is already installed."
    fi
  done
}

install_desktop_packages() {
  if [[ "$INSTALL_DESKTOP" == "y" ]]; then
    logger info "Installing desktop packages..."

    apt install -y --no-install-recommends "${desktop_packages[@]}"
    
    for package in "${!other_desktop_packages[@]}"; do
      local install_cmd="${other_desktop_packages[$package]}"
      if ! command -v "$package" &> /dev/null; then
        logger info "Installing $package..."
        eval "$install_cmd" || logger error "Failed to install $package"
      else
        logger done "$package is already installed."
      fi
    done
  else
    logger info "Skipping desktop install."
  fi
}
