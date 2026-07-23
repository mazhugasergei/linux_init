parse_arguments "$@"
is_running_as_root || { logger error "run this script as root (or via su -c)."; exit 1; }
logger info "starting installation script..."

confirm "Install minimal desktop apps?" && INSTALL_DESKTOP="y" || INSTALL_DESKTOP="n"

logger info "installing packages..."
apt update
install_packages

logger info "setting up fastfetch configuration..."
setup_fastfetch

logger info "setting up sudoers..."
setup_sudoers "$(get_real_user)"

INSTALL_DESKTOP="y" && logger info "installing desktop packages..."
INSTALL_DESKTOP="y" && install_desktop_packages

logger done "done."
confirm "Reboot now?" "Y" && sudo reboot now || logger info "reboot later to apply changes."
