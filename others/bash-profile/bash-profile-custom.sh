#!/bin/bash
# Author: José M. C. Noronha
# Some code has source: https://github.com/ChrisTitusTech/mybash

# shellcheck disable=SC2155

shopt -s expand_aliases # Enable alias to use on bash script

# ---------------------------------------------------------------------------- #
#                                    SYSTEM                                    #
# ---------------------------------------------------------------------------- #
function reboot {
    read -p "Will be restart PC. Continue(y/N)? " userInput
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
    local name
    local command
	while [ "$#" -ne 0 ] ; do
		case "${1}" in
			--name) name="$2"; shift 2 ;;
			--command) command="$2"; shift 2 ;;
			*) shift ;;
		esac
	done
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

# ----------------------------------- ALIAS ---------------------------------- #
alias editalias='nano ~/.bash_aliases'
alias editprofile='nano ~/.bashrc'
alias editcustomprofile='nano ~/.bash-profile-custom.sh'
alias reloadprofile='source ~/.bashrc'
alias ver='lsb_release -a'
alias cls='clear'


# ---------------------------------------------------------------------------- #
#                                   DIRECTORY                                  #
# ---------------------------------------------------------------------------- #
function gouserotherapps {
	local directory="$HOME\otherapps"
    if [[ $(directoryexists "$directory") == true ]]; then
        mkdir "$directory"
	fi
    cd "$directory" || mkdir "$directory"
}
function gouserconfig {
	local directory="$HOME\.config"
    if [[ $(directoryexists "$directory") == true ]]; then
        mkdir "$directory"
	fi
    cd "$directory"
}
function directoryexists {
	local file="$1"
    if [ -d "${file}" ]; then
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
function ldir {
	local cwd="$1"
	if [[ -z "${cwd}" ]]; then
		cwd="."
	fi
	find "$cwd" -maxdepth 1 -type d -not -path "$cwd" # directories only
}

# ----------------------------------- ALIAS ---------------------------------- #
alias deleteemptydirs="evaladvanced 'find . -empty -type d -delete -print'"
alias gohome='cd $HOME'
alias cd..='cd ..'
alias ..='cd ..'
alias cd...='d ../..'
alias ...='cd ../..'
alias cd....='cd ../../..'
alias ....='cd ../../..'
alias cd.....='cd ../../../..'
alias .....='cd ../../../..'
alias mkdir='mkdir -p'


# ---------------------------------------------------------------------------- #
#                                     FILE                                     #
# ---------------------------------------------------------------------------- #
function fileexists {
	local file="$1"
    if [ -f "${file}" ]; then
		echo true
	else
		echo false
    fi
}
function fileextension {
	local file="$1"
	if [[ $(echo "$file" | grep -o "\." | wc -l) -gt 0 ]]; then
		echo "${file##*.}"	
	fi
}
function filename {
	local file="$1"
	if [[ -n "${file}" ]]; then
		echo "${file%.*}"
	fi
}
function delfilelines {
	local file="$1"
	local match="$2"
	if [ "$(cat "$file" | grep -c "$match")" -ne 0 ]; then
        evaladvanced "grep -v 'alias $name' '$bash_alias' > '$bash_alias.tmp'"
        evaladvanced "mv '$bash_alias.tmp' '$bash_alias'"
    fi
}
function countfiles {
	find "$PWD" -maxdepth 1 | wc -l
}
function deletefile {
	local file="$1"
	if [[ $(fileexists "$file") == true ]]; then
		evaladvanced "rm -rf \"$file\""
	fi
}
function lf {
	local cwd="$1"
	if [[ -z "${cwd}" ]]; then
		cwd="."
	fi
	find "$cwd" -maxdepth 1 -type f # files only
}

# ----------------------------------- ALIAS ---------------------------------- #
alias findfile="find . | grep "
alias movefilestoparent="evaladvanced 'find . -mindepth 2 -type f -print -exec mv {} . \;'"


# ---------------------------------------------------------------------------- #
#                             Secure Hash Algorithm                            #
# ---------------------------------------------------------------------------- #
alias sha1='openssl sha1'
alias md5='openssl md5'
alias sha256='openssl sha256'


# ---------------------------------------------------------------------------- #
#                                     TOOLS                                    #
# ---------------------------------------------------------------------------- #
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
function execfilecommand {
	local file="$1"
	if [ -f "$file" ]; then
		while read -r line; do
			if [[ -n "${line}" ]]; then
				evaladvanced "$line"
			fi
		done < "$file"
	fi
}

function changedefaultjdk {
	local java_default_script_name="/etc/profile.d/jdk-default.sh"
	evaladvanced "update-java-alternatives --list"
	read -p "Insert Path of java(JAVA_HOME): " javaHome
	evaladvanced "echo \"JAVA_HOME_DEFAULT='${javaHome}'\" | sudo tee ${java_default_script_name}"
	evaladvanced "echo \"export JAVA_HOME=${javaHome}\" | sudo tee -a ${java_default_script_name}"
	evaladvanced "echo \"export PATH=\\$PATH:\\${JAVA_HOME_DEFAULT}/bin\" | sudo tee -a ${java_default_script_name}"
	evaladvanced "source ${java_default_script_name}"
}


# ----------------------------------- ALIAS ---------------------------------- #
alias cpadvanced='cp -Ri'
alias mvadvanced='mv -i'


# ---------------------------------------------------------------------------- #
#                                  NETWORKING                                  #
# ---------------------------------------------------------------------------- #
function openurl {
	local url="$1"
	xdg-open "$url"
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
function freeport {
	local port="$1"
	evaladvanced "sudo ss --kill state listening src ':$port'"
}


# ---------------------------------------------------------------------------- #
#                                    LOGGER                                    #
# ---------------------------------------------------------------------------- #
declare NO_COLOR='\033[0m'
function log {
    local message="$1"
    local keep_line=$2
    if [[ -n "${keep_line}" ]]&&[[ "${keep_line}" == "1" ]]; then
        echo -n "${message}" >&2
    else
        echo -e "${message}" >&2
    fi
}
function errorlog {
    local message="$1"
    local keep_line=$2
	local RED_COLOR='\033[0;31m'
    log "[${RED_COLOR}ERROR${NO_COLOR}] ${message}" "$keep_line"
}
function infolog {
    local message="$1"
    local keep_line=$2
	local BLUE_COLOR='\033[0;34m'
    log "[${BLUE_COLOR}INFO${NO_COLOR}] ${message}" "$keep_line"
}
function warnlog {
    local message="$1"
    local keep_line=$2
	local YELLOW_COLOR='\033[0;33m'
    log "[${YELLOW_COLOR}WARN${NO_COLOR}] ${message}" "$keep_line"
}
function oklog {
    local message="$1"
    local keep_line=$2
	local GREEN_COLOR='\033[0;32m'
    log "[${GREEN_COLOR}OK${NO_COLOR}] ${message}" "$keep_line"
}
function promptlog {
    local message="$1"
	local DARKGRAY_COLOR='\033[1;30m'
	declare BOLD_FOR_COLOR='\e[0m'
    log "${DARKGRAY_COLOR}>>>${BOLD_FOR_COLOR}${NO_COLOR} ${message}"
}
function titlelog {
	local message="$1"
	local message_len=${#message}
	local separator=""
	for (( i=1; i<=message_len+8; i++ )); do
		separator="#${separator}"
	done
	log "$separator"
	log "##  $message  ##"
	log "$separator"
}
function headerlog {
	local message="$1"
	log "##  $message  ##"
}


# ---------------------------------------------------------------------------- #
#                                      GIT                                     #
# ---------------------------------------------------------------------------- #
function gitresethardorigin {
	local current_branch_name="$(git branch --show-current)"
    git reset --hard origin/$current_branch_name
}
function gitresetfile() {
	fileName="$1"
	branch="$2"
	if [[ -f "$fileName" ]]; then
		if [[ -z "$branch" ]]; then
			branch="origin/master"
		fi
		evaladvanced "git checkout $branch '$fileName'"
	else
		errorlog "Invalid file - $fileName"
	fi
}

# ----------------------------------- ALIAS ---------------------------------- #
alias gitrepobackup="git clone --mirror"
alias gitreporestorebackup="git push --mirror"
alias gitundolastcommit="evaladvanced 'git reset --soft HEAD~1'"


# ---------------------------------------------------------------------------- #
#                                PACKAGES UTILS                                #
# ---------------------------------------------------------------------------- #
function npmupgrade {
	evaladvanced "npm outdated -g"
	evaladvanced "npm update -g"
}

function aptupgrade {
	evaladvanced "sudo apt update"
	evaladvanced "sudo apt upgrade -y"
}
function aptuninstall {
	evaladvanced "sudo apt purge --autoremove '$1' -y"
	evaladvanced "aptclean"
}
function aptclean {
	evaladvanced 'sudo apt autoremove -y'
	evaladvanced 'sudo apt autopurge -y'
	evaladvanced 'sudo apt autoclean -y'
	evaladvanced 'sudo apt clean --dry-run'
}

function flatpakupgrade {
	evaladvanced "flatpak update -y"
}
function flatpakuninstall {
	evaladvanced "flatpak uninstall --delete-data '$1' -y"
}
function flatpakclean {
	evaladvanced 'flatpak uninstall --unused -y'
	evaladvanced 'sudo rm -rfv /var/tmp/flatpak-cache*'
}

function snapupgrade {
	evaladvanced 'sudo snap refresh'
}
function snapuninstall {
	local configDir="$HOME/snap/$1"
	local configSystemDir="/snap/$1"
	evaladvanced "sudo snap remove --purge '$1'"
	evaladvanced "snap saved"
	read -p "Insert the number on the line of App(ENTER TO SKIP): " userInput	
	if [[ -n "${userInput}" ]]; then
		evaladvanced "sudo snap forget ${userInput}"
	fi
	if [ -d "$configDir" ]; then
		evaladvanced "rm -rf \"$configDir\""
	fi
	if [ -d "$configSystemDir" ]; then
		evaladvanced "sudo rm -rf \"$configSystemDir\""
	fi
}
function snapclean {
	evaladvanced "sudo sh -c 'rm -rf /var/lib/snapd/cache/*'"
	warnlog "Removes old revisions of snaps"
	read -n 1 -s -r -p "Please, CLOSE ALL SNAPS BEFORE RUNNING THIS. PRESS ANY KEY TO CONTINUE"
	log
	LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
		evaladvanced "sudo snap remove \"$snapname\" --revision=\"$revision\""
	done
}

function debgetupgrade {
	evaladvanced 'sudo deb-get update --repos-only'
	evaladvanced 'sudo deb-get upgrade'
}
function debgetclean {
	evaladvanced 'sudo deb-get clean'
}


# ----------------------------------- ALIAS ---------------------------------- #
alias systemupgrade="npmupgrade; log; aptupgrade; log; flatpakupgrade; log; snapupgrade; log; debgetupgrade"
alias systemclean="aptclean; log; flatpakclean; log; snapclean; log; debgetclean"
