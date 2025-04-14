#!/usr/bin/env bash
# Author: José M. C. Noronha
# shellcheck source=/dev/null
# shellcheck disable=SC2155
# shellcheck disable=SC2116

# Get Script directory
declare SCRIPT_UTILS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# ---------------------------------------------------------------------------- #
#                                    IMPORTS                                   #
# ---------------------------------------------------------------------------- #
for script in "${SCRIPT_UTILS_DIR}"/src/*.sh; do
    source "$script"
done

# ---------------------------------------------------------------------------- #
#                                  OPERATIONS                                  #
# ---------------------------------------------------------------------------- #
function create_dirs {
    local dirs=(
        "$HOME/.local/share/applications"
        "$HOME/Templates"
    )
    for dir in "${dirs[@]}"; do        
        if [[ -n "${dir}" ]]&&[[ ! -d "${dir}" ]]; then
            mkdir -p "${dir}"
        fi
    done
}

# ---------------------------------------------------------------------------- #
#                                     MAIN                                     #
# ---------------------------------------------------------------------------- #
create_dirs

