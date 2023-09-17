#!/bin/bash
# Autor: José M. C. Noronha
# shellcheck disable=SC2046
# shellcheck disable=SC2002

# ---------------------------------------------------------------------------- #
#                                   FUNCTIONS                                  #
# ---------------------------------------------------------------------------- #
function restart_so {
    local message="$1"
    local userInput
    if [[ -z "${message}" ]]; then
        message="Will be restart PC"
    fi
    userInput=$(read_user_keyboard "$message. Continue(y/N)?")
    if [[ "${userInput}" == "Y" ]] || [[ "${userInput}" == "y" ]]; then
        sudo shutdown -r now
    fi
    exit 0
}

function shutdown_so {
    local message="$1"
    if [[ -z "${message}" ]]; then
        message="Will be shutdown PC"
    fi
    userInput=$(read_user_keyboard "$message. Continue(Y/n)?")
    if [[ -z "${userInput}" ]] || [[ "${userInput}" == "Y" ]]; then
        sudo shutdown -h now
    fi
    exit 0
}

function has_internet_connection {
    if ! ping -c 1 8.8.8.8 -q &>/dev/null || ! ping -c 1 8.8.4.4 -q &>/dev/null || ! ping -c 1 time.google.com -q &>/dev/null; then
        false
        return
    fi
    true
    return
}

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
    if [[ -f "${autostart_file}" ]]; then
        rm "$autostart_file"
    fi
}

function create_bash_alias_file {
	local bash_alias="$HOME_DIR/.bash_aliases"
	if [ ! -f "$bash_alias" ]; then
		printf "Creating Bash alias file to run when bash start: %s\n" "$bash_alias"
		local data="# $AUTHOR
# Add alias on prompt: alias alias-name='command1 && command2...'
alias ..=\"cd ..\"
"
		echo "$data" | tee "${bash_alias}" > /dev/null
	fi

    # Default aliases
    add_alias "alias-config" "nano ~/.bash_aliases"
    add_alias "bashrc-config" "nano ~/.bashrc"
    add_alias "mkdir-p" "mkdir -pv"
    add_alias "filesize" "du -sh * | sort -h"
}

function add_alias {
    local name="$1"
    local command="$2"
    local bash_alias="$HOME_DIR/.bash_aliases"
    if [ $(cat "$bash_alias" | grep -c "^alias $name=") -ne 0 ]; then
        grep -v "alias $name" "$bash_alias" > "$bash_alias.tmp"
        mv "$bash_alias.tmp" "$bash_alias"
    fi
    echo "alias $name=\"$command\"" | tee -a "${bash_alias}" > /dev/null
}

function set_binaries_on_system {
    local binary="$1"
    local binaryname=$(basename "$binary")
    local destination="/usr/bin/$binaryname"
    eval_custom "sudo cp \"$binary\" \"$destination\""
    eval_custom "sudo chmod +x \"$destination\""
}

