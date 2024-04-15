#!/bin/bash
# Author: José M. C. Noronha
# Some code has source: https://github.com/ChrisTitusTech/mybash

shopt -s expand_aliases # Enable alias to use on bash script

function reboot {
    local message="Will be restart PC. Continue(y/N)? "
    read -p "$message" userInput
    if [[ "${userInput}" == "Y" ]] || [[ "${userInput}" == "y" ]]; then
        sudo "$(which shutdown)" -r now
    fi
}
function shutdown {
    read -p "Will be shutdown PC. Continue(Y/n)? " userInput
    if [[ -z "${userInput}" ]] || [[ "${userInput}" == "Y" ]]; then
        sudo "$(which shutdown)" -h now
    fi
}
function evaladvanced {
    local expression="$1"
    promptlog "$expression"
    eval "$expression"
}
function commandexists {
    local command="$1"
    if [ "$(command -v "$command")" ]; then
        echo true
    else
        echo false
    fi
}
function addalias {
    local bash_alias="$HOME_DIR/.bash_aliases"
    local name="$1"
    local command="$2"
    if [[ "--help" == "${name}" ]]||[[ "-h" == "${name}" ]]; then
        log "addalias NAME COMMAND"
        return
    fi
    delfilelines "$bash_alias" "^alias $name="
    echo "alias $name=\"$command\"" | tee -a "${bash_alias}" > /dev/null
}
function isadmin {
    if [ "$(id -u)" -eq 0 ]; then
        echo true
    else
        echo false
    fi
}
alias editalias='nano ~/.bash_aliases'
alias editprofile='nano ~/.bashrc'
alias editcustomprofile='nano ~/.bash-profile-custom.sh'
alias reloadprofile='source ~/.bashrc'
alias ver='lsb_release -a'
alias cls='clear'
