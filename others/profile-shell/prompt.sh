##!/usr/bin/env bash
# Author: José M. C. Noronha

IS_INIT_PROMPT=true

function isadmin {
    if [ "$(id -u)" -eq 0 ]; then
        echo true
    else
        echo false
    fi
}

build_prompt() {
    EXIT=$?               # save exit code of last command
    red='\[\e[0;31m\]'    # colors
    green='\[\e[0;32m\]'
    cyan='\[\e[1;36m\]'
    reset='\[\e[0m\]'
    PS1='${debian_chroot:+($debian_chroot)}'  # begin prompt

    if [ "$IS_INIT_PROMPT" == "true" ]; then
        PS1+="$cyan\w$reset\n"
        IS_INIT_PROMPT=false
    else
        PS1+="\n$cyan\w$reset\n"
    fi

    if [ $EXIT != 0 ]; then  # add arrow color dependent on exit code
        PS1+="$red"
    else
        PS1+="$green"
    fi
    PS1+="→$reset " # construct rest of prompt
}
PROMPT_COMMAND=build_prompt
