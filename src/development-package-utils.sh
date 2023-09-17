#!/bin/bash
# Autor: José M. C. Noronha
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
        local package_dir="${HOME_DIR}/.npm-packages"
        local script_node="${OTHER_APPS_DIR}/nodejs"
        local script_node_data="#!/bin/bash
NPM_PACKAGES=\"$package_dir\"
NODE_PATH=\"\$NPM_PACKAGES/lib/node_modules:\$NODE_PATH\"
export PATH=\"\$PATH:\$NPM_PACKAGES/bin\"
"
        eval_custom "mkdir -p \"$package_dir\""
        eval_custom "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -"
        eval_custom "sudo apt install nodejs -y"
        eval_custom "/usr/bin/npm config set prefix \"$package_dir\""
        echo "prefix=$package_dir" | tee "${HOME_DIR}/.npmrc"
        echo "$script_node_data" | tee "$script_node"
        eval_custom "chmod +x \"$script_node\""
        if [ "$(cat "$HOME_DIR/.bashrc" | grep -c "^. \"$script_node\"")" -eq 0 ]; then
            echo ". \"$script_node\"" | tee -a "$HOME_DIR/.bashrc"
        fi
        . "$HOME_DIR/.bashrc"
        eval_custom "/usr/bin/npm install -g typescript"
    fi
    add_alias "npm-upgrade" "npm outdated -g && npm update -g"
}

function install_python {
    if [[ $(show_message_dev "Python3/PIP/PIPX") == "y" ]]; then
        eval_custom "sudo apt install python3 -y"
        eval_custom "sudo apt install python3-pip -y"
        eval_custom "sudo apt install python3-venv -y"
        eval_custom "python3 -m venv .venv/anynamehere"
        eval_custom "sudo apt install pipx -y"
        eval_custom "pipx ensurepath"
    fi
}

function install_java {
    if [[ $(show_message_dev "Java") == "y" ]]; then
        eval_custom "sudo apt install openjdk-11-jdk -y"
        eval_custom "echo \"export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64\" | sudo tee /etc/profile.d/jdk18.sh"
        eval_custom "echo \"export PATH=\\$PATH:\\$JAVA_HOME/bin\" | sudo tee -a /etc/profile.d/jdk18.sh"
        eval_custom "source /etc/profile.d/jdk18.sh"
    fi
}

function install_maven {
    if [[ $(show_message_dev "Maven") == "y" ]]; then
        eval_custom "sudo apt install maven -y"
    fi
}

function install_cpp_c {
    if [[ $(show_message_dev "C/C++/Make/CLang/Objective-C") == "y" ]]; then
        eval_custom "sudo apt install build-essential g++ gcc gdb cmake make clang clangd clang-format clang-tidy clang-tools -y"
    fi
}

function install_php {
    if [[ $(show_message_dev "PHP") == "y" ]]; then
        eval_custom "sudo apt install php -y"
    fi
}

function install_go {
    if [[ $(show_message_dev "Go") == "y" ]]; then
        eval_custom "sudo apt install golang-go -y"
    fi
}

function install_sqlite3 {
    if [[ $(show_message_dev "Sqlite3") == "y" ]]; then
        info_log "\nDownload link example: https://www.sqlite.org/2022/sqlite-autoconf-{version}.tar.gz"
        download -u "https://www.sqlite.org/2022/sqlite-autoconf-3380200.tar.gz" -o "/tmp/sqlite-autoconf-3380200.tar.gz"
        eval_custom "sudo apt install build-essential libsqlite3-dev -y"
        eval_custom "tar xvfz /tmp/sqlite-autoconf-3380200.tar.gz"
        eval_custom "sudo mv sqlite-autoconf-3380200 /opt/sqlite3"
        eval_custom "cd /opt/sqlite3 && ./configure --prefix=/usr && sudo make install && cd -"
    fi
}

function install_postgres_sql {
    if [[ $(show_message_dev "Postgres SQL") == "y" ]]; then
        eval_custom "sudo apt install software-properties-common apt-transport-https wget -y"
        eval_custom "sudo wget -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /usr/share/keyrings/postgresql.gpg > /dev/null"
        eval_custom "echo \"deb [arch=amd64,arm64,ppc64el signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main\" | sudo tee /etc/apt/sources.list.d/postgresql.list > /dev/null"
        eval_custom "sudo apt update"
        if [[ $(show_message_dev "Postgres SQL - Server") == "y" ]]; then
            eval_custom "sudo apt install postgresql -y"
        fi
        if [[ $(show_message_dev "Postgres SQL - Client") == "y" ]]; then
            eval_custom "sudo apt install postgresql-client -y"
        fi
    fi
}
