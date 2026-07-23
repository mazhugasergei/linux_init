packages=(
  sudo
  git
  curl
  btop
  fastfetch
)

desktop_packages=(
  gnome-session
  gnome-shell
  gdm3
  gvfs
  gvfs-backends
  network-manager-gnome
  nautilus
  gnome-terminal
  gnome-tweaks
  gnome-text-editor
  gnome-system-monitor
  xdg-desktop-portal-gnome
  fonts-cantarell
)

declare -A other_packages=(
  [node]='wget -qO- https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs'
  [bun]='wget -qO- --show-progress https://bun.sh/install | bash'
  [docker]='wget -qO- https://get.docker.com | sudo sh && sudo usermod -aG docker "$USER"'
)

declare -A other_desktop_packages=(
  [brave]='curl -fsS https://dl.brave.com/install.sh | sh'
)
