#!/bin/bash
# Author: José M. C. Noronha

function cutadvanced {
    local delimiter data direction # direction = L/R
    CUT_PARSED_ARGUMENTS=$(getopt --longoptions data:,direction:,delimiter: -o "" -- "$@")
    CUT_VALID_ARGUMENTS=$?
    if [ "$CUT_VALID_ARGUMENTS" != "0" ]; then
        errorlog "Invalid arguments on Cut command"
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
            --help)
                log "cutadvanced --data DATA --delimiter DELIMITIER --direction [L|R]"
                return
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
function extract {
    local file="$1"
    if [ -f "$file" ] ; then
        case $file in
            *.tar.bz2)   tar xvjf "$file"    ;;
            *.tar.gz)    tar xvzf "$file"    ;;
            *.bz2)       bunzip2 "$file"     ;;
            *.rar)       rar x "$file"       ;;
            *.gz)        gunzip "$file"      ;;
            *.tar)       tar xvf "$file"     ;;
            *.tbz2)      tar xvjf "$file"    ;;
            *.tgz)       tar xvzf "$file"    ;;
            *.zip)       unzip "$file"       ;;
            *.Z)         uncompress "$file"  ;;
            *.7z)        7z x "$file"        ;;
            *)           infolog "don't know how to extract '$file'..." ;;
        esac
    else
        errorlog "'$file' is not a valid file!"
    fi
}
function openurl {
    local url="$1"
    if [[ -n "${url}" ]]; then
        xdg-open "$url"
    fi
}
function hasinternet {
    if ! ping -c 1 8.8.8.8 -q &>/dev/null || ! ping -c 1 8.8.4.4 -q &>/dev/null || ! ping -c 1 time.google.com -q &>/dev/null; then
        echo false
    else
        echo true
    fi
}
function mypubip {
    # Dumps a list of all IP addresses for every device
    # /sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ": " $3 }';
    
    ### Old commands
    # Internal IP Lookup
    #echo -n "Internal IP: " ; /sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'
    
    # External IP Lookup
    #echo -n "External IP: " ; wget http://smart-ip.net/myip -O - -q
    
    # Internal IP Lookup.
    if [ -e /sbin/ip ];
    then
        echo -n "Internal IP: " ; /sbin/ip addr show wlan0 | grep "inet " | awk -F: '{print $1}' | awk '{print $2}'
    else
        echo -n "Internal IP: " ; /sbin/ifconfig wlan0 | grep "inet " | awk -F: '{print $1} |' | awk '{print $2}'
    fi
    
    # External IP Lookup
    echo -n "External IP: " ; curl -s ifconfig.me
}
function download {
    local url
    local file
    while [ "$#" -ne 0 ] ; do
        case "${1}" in
            --url) url="$2"; shift 2 ;;
            --file) file="$2"; shift 2 ;;
						--help) log "download -url URL -file FILE"; return ;;
            *) shift ;;
        esac
    done
    if [ "$(hasinternet)" == false ]; then
        errorlog "No Internet connection available"
    else
        if [ "$(commandexists "wget")" == false ]; then
            evaladvanced "sudo apt install wget -y"
        fi
        wget -O "$file" "$url" -q --show-progress
    fi
}
alias sha1='openssl sha1'
alias md5='openssl md5'
alias sha256='openssl sha256'
function changedefaultjdk {
    local java_default_script_name="/etc/profile.d/jdk-default.sh"
    evaladvanced "update-java-alternatives --list"
    read -p "Insert Path of java(JAVA_HOME): " javaHome
    evaladvanced "echo \"JAVA_HOME_DEFAULT='${javaHome}'\" | sudo tee ${java_default_script_name}"
    evaladvanced "echo \"export JAVA_HOME=${javaHome}\" | sudo tee -a ${java_default_script_name}"
    evaladvanced "echo \"export PATH=\\$PATH:\\${JAVA_HOME_DEFAULT}/bin\" | sudo tee -a ${java_default_script_name}"
    evaladvanced "source ${java_default_script_name}"
}
