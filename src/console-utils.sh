#!/bin/bash
# Author: José M. C. Noronha
# shellcheck disable=SC2164
# shellcheck disable=SC2155
# shellcheck disable=SC2162
# shellcheck disable=SC2181

# ---------------------------------------------------------------------------- #
#                                   FUNCTIONS                                  #
# ---------------------------------------------------------------------------- #
function read_user_keyboard {
    local message="$1"
    read -p "$message " keyValue
    echo "$keyValue"
}

function read_user_keyboard_autocomplete {
    local message="$1"
    read -e -p "$message " imput
    echo "$imput"
}

function wait_for_any_key_pressed {
    local message="$1"
    if [[ -z "${message}" ]]; then
        message="Press any key to continue"
    fi
    read -n 1 -s -r -p "$message"
    log ""
}
