#!/bin/bash
# Author: José M. C. Noronha
# shellcheck disable=SC2155

function show_message_dev {
    local userInput=$(read_user_keyboard "Do you want to install $1? (y/N)")
    echo "$userInput"
}

function install_development_package {
    install_node_typescript_javascript
    install_python
    install_java
    install_maven
    install_cpp_c
    install_php
    install_go
    install_sqlite3
    install_postgres_sql
}

function install_node_typescript_javascript {
    if [[ $(show_message_dev "NodeJS/Javascript/Typescript") == "y" ]]; then
        evaladvanced "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash"
        # shellcheck source=/dev/null
        source "$HOME/.nvm/nvm.sh"
        evaladvanced "nvm install --lts"
        evaladvanced "npm install -g typescript"
    fi
}

function install_python {
    if [[ $(show_message_dev "Python3/PIP/PIPX") == "y" ]]; then
        evaladvanced "sudo apt install python3 -y"
        evaladvanced "sudo apt install python3-pip -y"
        evaladvanced "sudo apt install python3-venv -y"
        evaladvanced "python3 -m venv .venv/anynamehere"
        evaladvanced "sudo apt install pipx -y"
        evaladvanced "pipx ensurepath"
        evaladvanced "sudo apt install python-is-python3 -y"
    fi
}

function install_java {
    if [[ $(show_message_dev "Java") == "y" ]]; then
        evaladvanced "sudo apt install openjdk-11-jdk -y"
        headerlog "When asked for path of java"
        headerlog "Insert: /usr/lib/jvm/java-11-openjdk-amd64"
        changedefaultjdk
    fi
}

function install_maven {
    if [[ $(show_message_dev "Maven") == "y" ]]; then
        evaladvanced "sudo apt install maven -y"
    fi
}

function install_cpp_c {
    if [[ $(show_message_dev "C/C++/Make/CLang/Objective-C") == "y" ]]; then
        evaladvanced "sudo apt install build-essential g++ gcc gdb cmake make clang clangd clang-format clang-tidy clang-tools -y"
    fi
}

function install_php {
    if [[ $(show_message_dev "PHP") == "y" ]]; then
        evaladvanced "sudo apt install php -y"
    fi
}

function install_go {
    if [[ $(show_message_dev "Go") == "y" ]]; then
        evaladvanced "sudo add-apt-repository ppa:longsleep/golang-backports -y"
        evaladvanced "sudo apt install golang-go -y"
    fi
}

function install_sqlite3 {
    if [[ $(show_message_dev "Sqlite3") == "y" ]]; then
        infolog "\nDownload link example: https://www.sqlite.org/2022/sqlite-autoconf-{version}.tar.gz"
        evaladvanced "sudo apt install build-essential libsqlite3-dev -y"
        evaladvanced "sudo apt install sqlite3 -y"
    fi
}

function install_postgres_sql {
    if [[ $(show_message_dev "Postgres SQL") == "y" ]]; then
        evaladvanced "sudo apt install software-properties-common apt-transport-https wget -y"
        evaladvanced "sudo wget -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /usr/share/keyrings/postgresql.gpg > /dev/null"
        evaladvanced "echo \"deb [arch=amd64,arm64,ppc64el signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main\" | sudo tee /etc/apt/sources.list.d/postgresql.list > /dev/null"
        evaladvanced "sudo apt update"
        if [[ $(show_message_dev "Postgres SQL - Server") == "y" ]]; then
            evaladvanced "sudo apt install postgresql -y"
        fi
        if [[ $(show_message_dev "Postgres SQL - Client") == "y" ]]; then
            evaladvanced "sudo apt install postgresql-client -y"
        fi
    fi
}
