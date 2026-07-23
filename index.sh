is_running_as_root || { logger error "run this script as root (or via su -c)."; exit 1; }
parse_arguments "$@"

logger info "starting installation script..."
confirm "Install minimal desktop apps?" && INSTALL_DESKTOP="y" || INSTALL_DESKTOP="n"
apt update
install_packages
setup_fastfetch
setup_sudoers "$(get_real_user)"
install_desktop_packages

logger done "done."
confirm "Reboot now?" "Y" && sudo reboot now || logger info "reboot later to apply changes."
