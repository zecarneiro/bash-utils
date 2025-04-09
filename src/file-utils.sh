#!/usr/bin/env bash
# Author: José M. C. Noronha
# shellcheck disable=SC2155
# shellcheck disable=SC2164
# shellcheck disable=SC2005

# ---------------------------------------------------------------------------- #
#                                   FUNCTIONS                                  #
# ---------------------------------------------------------------------------- #
function create_shortcut_file {
    local name=""
    local exec_cmd=""
    local type_app="Application"
    local icon=""
    local path=""
    local comment=""
    local terminal=false
    local categories="Application"

    PARSED_ARGUMENTS=$(getopt --longoptions name:,exec:,type:,icon:,path:,comment:,terminal:,categories: -o "" -- "$@")
    VALID_ARGUMENTS=$?
    if [ "$VALID_ARGUMENTS" != "0" ]; then
        exit 1
    fi
    eval set -- "$PARSED_ARGUMENTS"
    while :; do
        case "$1" in
        --name)
            name="$2"; shift 2
            if [[ -z "${name}" ]]; then
                echo "Invalid argument: --name"
                exit 1
            fi
            ;;
        --exec)
            exec_cmd="$2"; shift 2
            if [[ -z "${exec_cmd}" ]]; then
                echo "Invalid argument: --exec"
                exit 1
            fi
            ;;
        --type) type_app="$2"; shift 2 ;;
        --icon) icon="$2"; shift 2 ;;
        --path) path="$2"; shift 2 ;;
        --comment) comment="$2"; shift 2 ;;
        --terminal)
            terminal="$2"; shift 2
            if [[ -z "${terminal}" ]]; then
                terminal=false
            elif [[ "${terminal}" != "true" ]]&&[[ "${terminal}" != "false" ]]; then
                echo "Invalid argument: --terminal must be a boolean [true|false]"
                exit 1
            fi
            ;;
        --categories) categories="$2"; shift 2 ;;
        --) shift; break ;;
        *) ;; # do nothing
        esac
    done
    local shortcut_file_name="${name// /-}"
    local shortcut_file="$HOME_DIR/.local/share/applications/${shortcut_file_name}.desktop"
    local data="[Desktop Entry]
Version=1.0
Name=${name}
Type=${type_app}
Icon=${icon}
Path=${path}
Comment=${comment}
Terminal=${terminal}
Categories=${categories};"
    echo "${data}" | tee "${shortcut_file}" >/dev/null
    if [[ "${terminal}" == "true" ]]; then
        echo "Exec=bash -ic \"${exec_cmd}; read -n 1 -s -r -p 'Press any key to continue...'\"" | tee -a "${shortcut_file}" >/dev/null
    else
        echo "Exec=${exec_cmd}" | tee -a "${shortcut_file}" >/dev/null
    fi
    sudo chmod +x "${shortcut_file}"
    echo "Created shortcut: ${shortcut_file}"
}

function del_shortcut_file {
    local name="$1"
    local shortcut_file_name="${name// /-}"
    local shortcut_file="$HOME_DIR/.local/share/applications/${shortcut_file_name}.desktop"
    deletefile "${shortcut_file}"
}
