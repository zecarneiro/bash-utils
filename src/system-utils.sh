#!/bin/bash
# Author: José M. C. Noronha
# shellcheck disable=SC2046
# shellcheck disable=SC2002

# ---------------------------------------------------------------------------- #
#                                   FUNCTIONS                                  #
# ---------------------------------------------------------------------------- #
function add_boot_application {
    local name="$1"
    local command="$2"
    local hidden="$3"
    local file_name="${name/ /"_"}"
    local autostart_file="$CONFIG_DIR/autostart/$file_name.desktop"
    echo "[Desktop Entry]" >"$autostart_file"
    echo "Name=$name" | tee -a "$autostart_file" >/dev/null
    echo "Type=Application" | tee -a "$autostart_file" >/dev/null
    echo "Exec=$command" | tee -a "$autostart_file" >/dev/null
    if [[ "$hidden" -eq 1 ]]; then
        echo "Terminal=false" | tee -a "$autostart_file" >/dev/null
    else
        echo "Terminal=true" | tee -a "$autostart_file" >/dev/null
    fi
}

function del_boot_application {
    local name="$1"
    local file_name="${name/ /"_"}"
    local autostart_file="$CONFIG_DIR/autostart/$file_name.desktop"
    if [ $(fileexists "${autostart_file}") == true ]; then
        rm "$autostart_file"
    fi
}

function create_profile_file {
    local profilesShellDir="${OTHER_APPS_DIR}/profile-shell"
    local bashrc="$HOME/.bashrc"
    cp -r "$SCRIPT_UTILS_DIR/others/profile-shell" "$OTHER_APPS_DIR"
    if [[ $(cat "$bashrc" | grep -c "$profilesShellDir") -le 0 ]]; then
        echo "for profileShellFile in \"$profilesShellDir\"/*.sh; do source \"\$profileShellFile\"; done" | tee -a "$bashrc" >/dev/null
    fi
    infolog "Please, Restart the Terminal to change take effect!"
}

function set_binaries_on_system {
    local binary="$1"
    local binaryname=$(basename "$binary")
    local destination="/usr/bin/$binaryname"
    eval "sudo cp \"$binary\" \"$destination\""
    eval "sudo chmod +x \"$destination\""
}
