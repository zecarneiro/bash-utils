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

function confirm {
    local status=false
    local message="$1"
    local isYesDefault="$2"
    if [[ "${isYesDefault}" == "true" ]]; then
        message="${message}? [Y/n]"
    else
        message="${message}? [y/N]"
    fi

    local res=$(read_user_keyboard "$message")
    if [[ "$isYesDefault" == "true" ]] && [[ -z "${res}" ]]; then
        status="true"
    elif [[ "${res}" == "y" ]] || [[ "${res}" == "Y" ]]; then
        status="true"
    fi
    echo $status
}
