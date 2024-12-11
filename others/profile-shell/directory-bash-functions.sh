##!/usr/bin/env bash
# Author: José M. C. Noronha

function gouserotherapps {
    local directory="$HOME\.otherapps"
    if [[ $(directoryexists "$directory") == true ]]; then
        mkdir -p "$directory"
    fi
    cd "$directory" || mkdir -p "$directory"
}
function gouserconfig {
    local directory="$HOME\.config"
    if [[ $(directoryexists "$directory") == true ]]; then
        mkdir -p "$directory"
    fi
    cd "$directory"
}
function directoryexists {
    local directory="$1"
    if [ -d "${directory}" ]; then
        echo true
    else
        echo false
    fi
}
function deletedirectory {
    local directory="$1"
    if [[ $(directoryexists "$directory") == true ]]; then
        evaladvanced "rm -rf \"$directory\""
    fi
}
alias deleteemptydirs="evaladvanced 'find . -empty -type d -delete -print'"
alias gohome='cd $HOME'
alias cd..='cd ..'
alias ..='cd ..'
function ldir {
    find "." -maxdepth 1 -type d -not -path "." # directories only
}
alias countdirs="find . -type d | wc -l"
alias mkdir="mkdir -p"
function tempdir {
    echo "/tmp"
}
