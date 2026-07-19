is_running_as_root || { echo "Run this script as root (or via su -c)."; exit 1; }

apt update
install_must_have_packages
setup_fastfetch
setup_sudoers "$(get_real_user)"
install_desktop_packages

logger done "Done."
