packages=(
  sudo
  git
  gh
  curl
  btop
  fastfetch
  unzip
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
  [bun]='su - "$(get_real_user)" -c "wget -qO- https://bun.sh/install | bash"'
  [docker]='wget -qO- https://get.docker.com | sudo sh && sudo usermod -aG docker "$(get_real_user)"'
  [rustc]='su - "$(get_real_user)" -c "wget -qO- https://sh.rustup.rs | sh -s -- -y"'
  [go]='GOVER=$(wget -qO- "https://go.dev/VERSION?m=text" | head -n1) && wget -qO- "https://go.dev/dl/${GOVER}.linux-amd64.tar.gz" | sudo tar -C /usr/local -xz && echo "export PATH=\$PATH:/usr/local/go/bin" | sudo tee /etc/profile.d/go.sh > /dev/null'
)

declare -A other_desktop_packages=(
  [brave]='wget -qO- https://dl.brave.com/install.sh | sh'
)
