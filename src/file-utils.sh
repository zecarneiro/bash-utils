#!/bin/bash
# Autor: José M. C. Noronha
# shellcheck disable=SC2155
# shellcheck disable=SC2164
# shellcheck disable=SC2005

# ---------------------------------------------------------------------------- #
#                                   FUNCTIONS                                  #
# ---------------------------------------------------------------------------- #
function dirname_custom {
    local file="$1"
    log_log "$(dirname "$file")"
}

function basename_custom {
    local file="$1"
    log_log "$(basename "$file")"
}

function get_working_dir {
    log_log "$(pwd)"
}

function is_directory {
    local file="$1"
    if [[ -d "$file" ]]; then
        true
        return
    fi
    false
    return
}

function file_delete {
    local file="$1"
    if file_exist "${file}"; then
        if is_directory "${file}"; then
            eval_custom "rm -rf \"${file}\""
        else
            eval_custom "rm \"${file}\""
        fi
    else
        warnning_log "File not exist: ${file}"
    fi
}

function create_directory {
    local file="$1"
    if ! is_directory "${file}"; then
        eval_custom "mkdir -p \"${file}\""
    fi
}

function write_file {
    local file append data
    # shellcheck disable=SC2214
    local opt OPTARG OPTIND
    while getopts 'f:a:d' opt; do
        case "${opt}" in
        f) file=${OPTARG} ;;
        a) append=${OPTARG} ;;
        d) data=${OPTARG} ;;
        *) ;;
        esac
    done
    if [[ "$append" -eq 1 ]]; then
        echo "$data" | tee -a "$file" >/dev/null
    else
        echo "$data" >"$file"
    fi
}

function file_exist {
    local file="$1"
    if is_directory "${file}" || [ -f "${file}" ]; then
        true
        return
    fi
    false
    return
}

function download {
    local uri outfile
    # shellcheck disable=SC2214
    local opt OPTARG OPTIND
    while getopts 'u:o:' opt; do
        case "${opt}" in
        u) uri=${OPTARG} ;;
        o) outfile=${OPTARG} ;;
        *) return 1 ;;
        esac
    done
    if has_internet_connection; then
        if ! command_exist "wget"; then
            eval_custom "sudo apt install wget -y"
        fi
        wget -O "$outfile" "$uri" -q --show-progress
    else
        error_log "No Internet connection available"
    fi
}

function svg_to_png {
    local svg_file="$1"
    local png_file="$2"
    if file_exist "$svg_file"; then
        local png_dir="$(dirname_custom "$png_file")"
        create_directory "$png_dir"
        eval_custom "inkscape \"$svg_file\" -o \"$png_file\" --export-overwrite -w 32 -h 32"
    fi
}

function define_default_system_dir {
    local result=$(read_user_keyboard "Insert all User Dirs? (y/N)")
    if [[ "${result}" == "y" ]]; then
        local -A user_dirs
        result=$(read_user_keyboard_autocomplete "Insert DOWNLOAD (Or ENTER to cancel)")
        if [ -d "$result" ]; then
            user_dirs[DOWNLOAD]="$result"
        fi
        result=$(read_user_keyboard_autocomplete "Insert TEMPLATES (Or ENTER to cancel)")
        if [ -d "$result" ]; then
            user_dirs[TEMPLATES]="$result"
        fi
        result=$(read_user_keyboard_autocomplete "Insert DOCUMENTS (Or ENTER to cancel)")
        if [ -d "$result" ]; then
            user_dirs[DOCUMENTS]="$result"
        fi
        result=$(read_user_keyboard_autocomplete "Insert MUSIC (Or ENTER to cancel)")
        if [ -d "$result" ]; then
            user_dirs[MUSIC]="$result"
        fi
        result=$(read_user_keyboard_autocomplete "Insert PICTURES (Or ENTER to cancel)")
        if [ -d "$result" ]; then
            user_dirs[PICTURES]="$result"
        fi
        result=$(read_user_keyboard_autocomplete "Insert VIDEOS (Or ENTER to cancel)")
        if [ -d "$result" ]; then
            user_dirs[VIDEOS]="$result"
        fi
        for key in "${!user_dirs[@]}"; do
            eval_custom "xdg-user-dirs-update --set $key \"${user_dirs[$key]}\""
        done
    fi
}

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

function view_markdown {
    local file="${1}"
    "$OTHER_APPS_DIR/mdview.AppImage" "$file"
}
