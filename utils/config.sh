# Create fastfetch configuration
# Usage: setup_fastfetch
# Returns: 0 on success, 1 on failure
setup_fastfetch() {
	local fastfetch_dir="$HOME/.config/fastfetch"
	local config_file="$fastfetch_dir/config.jsonc"
	
	logger info "setting up fastfetch configuration..."
	
	# Create directory if it doesn't exist
	if [ ! -d "$fastfetch_dir" ]; then
		mkdir -p "$fastfetch_dir" || {
			logger error "failed to create fastfetch directory"
			return 1
		}
	fi
	
	# Create the configuration file
	cat > "$config_file" << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "data",
    "source": "\u001b[97m  ▄▀▄▀▀▀▀▄▀▄\n  █        ▀▄      ▄\n █  ▀  ▀     ▀▄▄  █ █\n █ ▄ █▀ ▄       ▀▀  █\n █  ▀▀▀▀            █\n █                  █\n █                  █\n  █  ▄▄  ▄▄▄▄  ▄▄  █\n  █ ▄▀█ ▄▀  █ ▄▀█ ▄▀\n   ▀   ▀     ▀   ▀\u001b[0m",
    "padding": {
      "top": 1,
      "left": 1
    }
  },
  "display": {
    "color": {
      "keys": "90",
      "title": "90"
    }
  },
  "modules": [
    "title",
    "separator",
    "os",
    "host",
    "kernel",
    "uptime",
    "packages",
    "shell",
    "wm",
    "terminal",
    "cpu",
    "gpu",
    "memory",
    "swap",
    "disk",
    "localip",
    "battery",
    "locale"
  ]
}
EOF
	
	clear_previous_line
	if [ $? -eq 0 ]; then
		logger done "fastfetch configuration created"
		return 0
	else
		logger error "failed to create fastfetch configuration"
		return 1
	fi
}
