is_running_as_root || { logger error "Run this script as root (or via su -c)."; exit 1; }

logger info "Starting installation script..."
confirm "Install minimal desktop apps (GNOME + Brave)?" && INSTALL_DESKTOP="y" || INSTALL_DESKTOP="n"
apt update
install_must_have_packages
setup_fastfetch
setup_sudoers "$(get_real_user)"
install_desktop_packages
logger done "Done."
confirm "Reboot now?" "Y" && "echo 'sudo reboot now' && sudo reboot now" || logger info "Reboot later to apply changes."
