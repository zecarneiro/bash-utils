##!/usr/bin/env bash
# Author: José M. C. Noronha

function compile {
    local cmd="$1"
    local cwd="$2"
    local currentDir="$(echo "$PWD")"
    info_log "Compiling..."
    cd "$cwd"
    evaladvanced "$cmd"
    cd "$currentDir"
}