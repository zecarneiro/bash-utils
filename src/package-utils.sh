#!/bin/bash
# Autor: José M. C. Noronha
# shellcheck disable=SC2155
# shellcheck disable=SC2164
# shellcheck disable=SC2046
# shellcheck disable=SC2140
# shellcheck disable=SC2002

# ---------------------------------------------------------------------------- #
#                                   FUNCTIONS                                  #
# ---------------------------------------------------------------------------- #
function install_all_packages() {
    install_apt
    install_flatpak
    install_snap
    install_deb_get
    install_pacstall
    install_appimage
    install_installers
}

function install_apt {
    log_log "\nAdd Multiverse and Universe Respositories"
    eval_custom "sudo add-apt-repository universe -y"
    eval_custom "sudo add-apt-repository multiverse -y"

    log_log "\nUpdate APT Repository"
    eval_custom "sudo apt update"

    log_log "\nUpgrade APT Package"
    eval_custom "sudo apt upgrade -y"
    add_alias "apt-upgrade" "sudo apt update && sudo apt upgrade -y"
    add_alias "apt-clean" "sudo apt autoremove -y && sudo apt autopurge -y && sudo apt autoclean -y && sudo apt clean --dry-run"
    
    info_log "Install apt-uninstall"
    echo "#!/bin/bash

declare APP=\"\$1\"

if [[ -z \"\${APP}\" ]]; then
    echo \"Invalid app to uninstall\"
    exit 1
fi

exec_cmd() {
    local cmd=\"\$1\"
    echo \">>> $cmd\"
    eval \"$cmd\"
}

exec_cmd \"sudo apt purge --autoremove $APP -y\"
exec_cmd \"sudo apt autoremove -y\"
exec_cmd \"sudo apt clean -y\"
exec_cmd \"sudo apt autopurge -y\"
exec_cmd \"sudo apt autoclean -y\"
    " | tee "${APPS_BIN_DIR}/apt-uninstall" > /dev/null
    set_binaries_on_system "${APPS_BIN_DIR}/apt-uninstall"
    install_base_apt_package
}
function install_base_apt_package {
    eval_custom "sudo apt install apt-transport-https -y"
    if ! command_exist "wget"; then
        log_log "\nInstall Wget"
        eval_custom "sudo apt install wget -y"
    fi
    if ! command_exist "curl"; then
        log_log "\nInstall cUrl"
        eval_custom "sudo apt install curl -y"
    fi
    if ! command_exist "inkscape"; then
        log_log "\nInstall inkscape"
        eval_custom "sudo apt install inkscape -y"
    fi
    if ! command_exist "git"; then
        log_log "\nInstall Git"
        eval_custom "sudo apt install git -y"
    fi
    add_alias "git-repo-backup" "git clone --mirror"
    add_alias "git-repo-restore-backup" "git push --mirror"
}

function install_flatpak {
    if ! command_exist "flatpak"; then
        log_log "\nInstall Flatpak"
        eval_custom "sudo apt install gnome-software gnome-software-plugin-flatpak xdg-desktop-portal-gtk flatpak -y"
        eval_custom "flatpak remote-add --if-not-exists flathub 'https://flathub.org/repo/flathub.flatpakrepo'"
    fi
    add_alias "flatpak-upgrade" "flatpak update -y"
    add_alias "flatpak-uninstall" "flatpak uninstall --delete-data"
    add_alias "flatpak-clean" "flatpak uninstall --unused -y && sudo rm -rfv /var/tmp/flatpak-cache*"
}

function install_snap {
    if ! command_exist "snap"; then
        log_log "\nInstall Snap"
        eval_custom "sudo apt install snapd-xdg-open snapd -y"
    fi
    add_alias "snap-upgrade" "sudo snap refresh"
    add_alias "snap-uninstall" "sudo snap remove --purge"

    info_log "Install snap-clean"
    echo "#!/bin/bash
# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu
LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print \$1, \$3}' | while read snapname revision; do
    sudo snap remove \"\$snapname\" --revision=\"\$revision\"
done
sudo rm -rfv /var/lib/snapd/cache/
    " | tee "${APPS_BIN_DIR}/snap-clean" > /dev/null
    set_binaries_on_system "${APPS_BIN_DIR}/snap-clean"
}

function install_deb_get {
    # Info Link: https://github.com/wimpysworld/deb-get
    if ! command_exist "deb-get"; then
        log_log "\nInstall Deb-Get"
        if ! command_exist "curl"; then
            eval_custom "sudo apt install curl -y"
        fi
        eval_custom "curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get"
    fi
    add_alias "deb-get-clean" "sudo deb-get clean"
    add_alias "deb-get-upgrade" "sudo deb-get update --repos-only && sudo deb-get upgrade"
}

function install_pacstall {
    if ! command_exist "pacstall"; then
        log_log "\nInstall Pacstall"
        download -u "https://pacstall.dev/q/install" -o "$APPS_BIN_DIR/install_pacstall.sh"
        eval_custom "chmod +x \"$APPS_BIN_DIR/install_pacstall.sh\""
        eval_custom "sudo \"$APPS_BIN_DIR/install_pacstall.sh\""
    fi
}

function install_appimage {
    log_log "\nEnable AppImage Support in Ubuntu"
    eval_custom "sudo apt install libfuse2 -y"
    install_base_appimage_package
}
function install_base_appimage_package {
    if [ ! -f "$OTHER_APPS_DIR/mdview.AppImage" ]; then
        log_log "\nInstall Markdown Viewer"
        download -u "https://github.com/c3er/mdview/releases/download/v2.7.0/mdview-2.7.0-x86_64.AppImage" -o "$OTHER_APPS_DIR/mdview.AppImage"
        chmod +x "$OTHER_APPS_DIR/mdview.AppImage"
        create_shortcut_file --name "Markdown Viewer" --exec "$OTHER_APPS_DIR/mdview.AppImage"
    fi
}

function install_installers {
    if ! command_exist "gdebi"; then
        log_log "\nInstall Gdebi(DEB installers)"
        eval_custom "sudo apt install gdebi -y"
    fi
    if ! command_exist "alien"; then
        log_log "\nInstall Alien(RPM Installer)"
        eval_custom "sudo apt install alien -y"
    fi
}
