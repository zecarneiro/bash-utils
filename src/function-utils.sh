#!/bin/bash
# Autor: José M. C. Noronha
# shellcheck disable=SC2155
# shellcheck disable=SC2164
# shellcheck disable=SC2001
# shellcheck disable=SC2005
# shellcheck disable=SC2034
# shellcheck disable=SC2086

# ---------------------------------------------------------------------------- #
#                                   FUNCTIONS                                  #
# ---------------------------------------------------------------------------- #
function is_admin {
    if [ "$(id -u)" -eq 0 ]; then
        true
        return
    fi
    false
    return
}

function cut_custom {
    local delimiter data direction # direction = L/R
    CUT_PARSED_ARGUMENTS=$(getopt --longoptions data:,direction:,delimiter: -o "" -- "$@")
    CUT_VALID_ARGUMENTS=$?
    if [ "$CUT_VALID_ARGUMENTS" != "0" ]; then
        error_log "Invalid arguments on Cut command"
        return 1
    fi
    eval set -- "$CUT_PARSED_ARGUMENTS"
    while :; do
        case "$1" in
        --direction)
            direction=$2
            shift 2
            ;;
        --delimiter)
            delimiter=$2
            shift 2
            ;;
        --data)
            data=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        esac
    done
    if [[ -n "${data}" ]]; then
        if [[ "${direction}" == "R" ]]; then
            data="$(echo "$data" | awk -F "$delimiter" '{ print $2 }')"
        elif [[ "${direction}" == "L" ]]; then
            data="$(echo "$data" | awk -F "$delimiter" '{ print $1 }')"
        fi
        echo "$data"
    fi
}

function grep_custom {
    local file regex
    # shellcheck disable=SC2214
    local opt OPTARG OPTIND
    while getopts ":f:r:" opt; do
        case "${opt}" in
        f) file=${OPTARG} ;;
        r) regex=${OPTARG} ;;
        *) ;;
        esac
    done
    # shellcheck disable=SC2002
    # shellcheck disable=SC2005
    echo "$(cat "$file" | grep "$regex")"
}

function trim_custom() {
    local data characters
    # shellcheck disable=SC2214
    local opt OPTARG OPTIND
    while getopts ":d:c:" opt; do
        case "${opt}" in
        d) data=${OPTARG} ;;
        c) characters=${OPTARG} ;;
        *) ;;
        esac
    done
    if [ -z "$characters" ]; then
        characters='" "\n\r'
    fi
    echo "$(echo "$data" | sed "s/[$characters]//g")"
}

remove_word() (
    set -f
    IFS=' '

    s=$1
    w=$2

    set -- $1
    for arg; do
        shift
        [ "$arg" = "$w" ] && continue
        set -- "$@" "$arg"
    done

    printf '%s\n' "$*"
)
