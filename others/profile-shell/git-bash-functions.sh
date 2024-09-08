#!/bin/bash
# Author: José M. C. Noronha

function gitresethardorigin {
    local current_branch_name="$(git branch --show-current)"
    git reset --hard origin/$current_branch_name
}
function gitresetfile {
    fileName="$1"
    branch="$2"
    if [[ "--help" == "${fileName}" ]]||[[ "-h" == "${fileName}" ]]; then
        log "gitresetfile FILENAME BRANCH"
        return
    fi
    if [[ -f "$fileName" ]]; then
        if [[ -z "$branch" ]]; then
            branch="origin/master"
        fi
        evaladvanced "git checkout $branch '$fileName'"
    else
        errorlog "Invalid file - $fileName"
    fi
}
function gitrepobackup {
	local url="$1"
	git clone --mirror "$url"
}
function gitreporestorebackup {
	local url="$1"
	git push --mirror "$url"
}
alias gitundolastcommit="evaladvanced 'git reset --soft HEAD~1'"
function gitmovsubmodule {
    local old="$1"
    local new="$2"
    local newParentDir="$(dirname "$new")"
    mkdir -p "$newParentDir"
    git mv "$old" "$new"
}
function gitaddscriptperm {
    local script="$1"
    git update-index --chmod=+x "$script"
    git ls-files --stage | grep "$script"
}