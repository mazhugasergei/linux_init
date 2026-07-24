parse_arguments "$@"
is_running_as_root || { logger error "run this script as root (or via su -c)."; exit 1; }
logger info "starting installation script..."

confirm "Install minimal desktop apps?" && INSTALL_DESKTOP="y" || INSTALL_DESKTOP="n"

logger info "installing packages..."
apt update
install_packages

setup_fastfetch

setup_sudoers "$(get_real_user)"

if [ "$INSTALL_DESKTOP" = "y" ]; then
  logger info "installing desktop packages..."
  install_desktop_packages
fi

logger done "installation script completed"
confirm "Reboot now?" "Y" && sudo reboot now || logger info "reboot later to apply changes"
