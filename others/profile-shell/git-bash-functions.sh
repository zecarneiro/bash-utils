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
function gitcherrypickmaster {
    local commit="$1"
    git cherry-pick -m 1 "$commit"
}
function gitcherrypickmastercontinue {
    git cherry-pick --continue
}
alias gitclone="git clone"
function githubchangeurl() {
    read -p "Github Username: " username
    read -p "Github Token: " token
    read -p "Github URL end path(ex: AAA/bbb.gi): " urlEndPath
    local url="https://${username}:${token}@github.com/$urlEndPath"
    infolog "Set new github URL: $url"
    git remote set-url origin "$url"
}
function gitglobalconfig() {
    evaladvanced "git config --global core.autocrlf input"
    evaladvanced "git config --global core.fileMode false"
    evaladvanced "git config --global core.logAllRefUpdates true"
    evaladvanced "git config --global core.ignorecase true"
    evaladvanced "git config --global pull.rebase true"
    evaladvanced "git config --global --add safe.directory '*'"
    evaladvanced "git config --global merge.ff false"
}
function gitconfiguser() {
    read -p "Username: " username
    read -p "Email: " email
    evaladvanced "git config user.name \"$username\""
    evaladvanced "git config user.email \"$email\""
}
alias gitcommit="git commit -m"
alias gitstageall="git add ."
alias gitstatus="git status"
function gitlatestversionrepo() {
    local owner="$1"
    local repo="$2"
    local url="https://api.github.com/repos/$owner/$repo/releases"
    local version=$(curl -s "$url" | grep -Po '"tag_name": "v\K[^"]*' | head -n 1)
    echo "$version"
}
