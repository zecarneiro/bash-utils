#!/bin/bash
# Autor: José M. C. Noronha

declare NO_COLOR='\033[0m'
declare RED_COLOR='\033[0;31m'
declare BLUE_COLOR='\033[0;34m'
declare YELLOW_COLOR='\033[0;33m'
declare GREEN_COLOR='\033[0;32m'
declare DARKGRAY_COLOR='\033[1;30m'
declare BOLD_FOR_COLOR='\e[0m'

# ---------------------------------------------------------------------------- #
#                                   FUNCTIONS                                  #
# ---------------------------------------------------------------------------- #
function log_log {
    local message="$1"
    local keep_line=$2
    if [[ -n "${keep_line}" ]]&&[[ "${keep_line}" == "1" ]]; then
        echo -n "${message}" >&2
    else
        echo -e "${message}" >&2
    fi
}

function error_log {
    local message="$1"
    local keep_line=$2
    log_log "[${RED_COLOR}ERROR${NO_COLOR}] ${message}" "$keep_line"
}

function info_log {
    local message="$1"
    local keep_line=$2
    log_log "[${BLUE_COLOR}INFO${NO_COLOR}] ${message}" "$keep_line"
}

function warnning_log {
    local message="$1"
    local keep_line=$2
    log_log "[${YELLOW_COLOR}WARN${NO_COLOR}] ${message}" "$keep_line"
}

function success_log {
    local message="$1"
    local keep_line=$2
    log_log "[${GREEN_COLOR}OK${NO_COLOR}] ${message}" "$keep_line"
}

function prompt_log {
    local message="$1"
    log_log "${DARKGRAY_COLOR}>>>${BOLD_FOR_COLOR}${NO_COLOR} ${message}"
}
