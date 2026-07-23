print_help() {
	echo "Usage: $0 [OPTIONS]"
	echo ""
	echo "OPTIONS:"
	echo "  -h, --help					Show this help message"
	echo ""
}

# Parse command line arguments
# Usage: parse_arguments "$@"
# Sets global variables: INSTALLATION_ERROR
parse_arguments() {
	# Initialize default values
	SHOW_EFFECTS=false
	INSTALLATION_ERROR=false
	
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-h|--help)
				print_help
				exit 0
				;;
			-*)
				# Handle combined short flags
				flags=$(echo "$1" | sed 's/^-//')
				for flag in $(echo "$flags" | fold -w1); do
					case "$flag" in
						e)
							# Count 'e' flags to determine behavior
							e_count=$(echo "$flags" | grep -o 'e' | wc -l)
							if [ $e_count -eq 1 ]; then
								SHOW_EFFECTS=true
							elif [ $e_count -gt 1 ]; then
								# Multiple 'e's means effects + errored
								SHOW_EFFECTS=true
								FORCE_ERROR=true
							fi
							;;
						*)
							echo "Unknown option: -$flag"
							print_help
							exit 1
							;;
					esac
				done
				shift
				;;
			*)
				echo "Unknown option: $1"
				print_help
				exit 1
				;;
		esac
	done
}
