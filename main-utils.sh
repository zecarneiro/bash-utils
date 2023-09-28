#!/bin/bash
# Author: José M. C. Noronha
# shellcheck source=/dev/null
# shellcheck disable=SC2155
# shellcheck disable=SC2116

# Get Script directory
declare SCRIPT_UTILS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# ---------------------------------------------------------------------------- #
#                                    IMPORTS                                   #
# ---------------------------------------------------------------------------- #
source "${SCRIPT_UTILS_DIR}/others/bash-profile/bash-profile-custom.sh"
for script in "${SCRIPT_UTILS_DIR}"/src/*.sh; do
	source "$script"
done

# ---------------------------------------------------------------------------- #
#                                   VARIABLE                                   #
# ---------------------------------------------------------------------------- #
declare TEMP_DIR=$(mktemp -d)
declare HOME_DIR="$(echo "$HOME")"
declare OTHER_APPS_DIR="$HOME_DIR/otherapps"
declare CONFIG_DIR="$HOME_DIR/.config"
declare APPS_DIR="${TEMP_DIR}/apps"
declare APPS_BIN_DIR="$APPS_DIR/bin"

# ---------------------------------------------------------------------------- #
#                                  OPERATIONS                                  #
# ---------------------------------------------------------------------------- #
function create_dirs {
	local dirs=(
		"$OTHER_APPS_DIR"
		"$CONFIG_DIR"
		"$HOME_DIR/.config/autostart"
		"$HOME_DIR/.local/share/applications"
		"$HOME_DIR/Templates"
		"$APPS_BIN_DIR"
	)
	for dir in "${dirs[@]}"; do
		if [[ ! -d "${dir}" ]]; then
			mkdir "${dir}"
		fi
	done
}

# ---------------------------------------------------------------------------- #
#                                     MAIN                                     #
# ---------------------------------------------------------------------------- #
create_dirs

