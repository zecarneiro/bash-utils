#!/bin/bash

function compile {
    local cmd="$1"
    local cwd="$2"
    local currentDir="$(echo "$PWD")"
    info_log "Compiling..."
    cd "$cwd"
    eval_custom "$cmd"
    cd "$currentDir"
}