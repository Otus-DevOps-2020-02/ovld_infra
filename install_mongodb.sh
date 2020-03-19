#!/bin/bash

FILE="/etc/apt/sources.list.d/mongodb-org-3.2.list"

function update() {
    echo 'Update the package lists from the repos'
    sudo apt update
    if [ $? -ne 0 ]; then
        echo "Update the package lists has failed"
        exit 1
    fi
}


function add_mongo_repo() {
    if ( ! sudo apt-key finger|grep -q mongo ) ; then wget -qO - https://www.mongodb.org/static/pgp/server-3.2.asc | sudo apt-key add -; fi
    [ ! -f "$FILE" ] && { echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee $FILE; }
}

function start_mongo() {
    if ( ! sudo systemctl is-active --quiet mongod); then sudo systemctl restart mongod; fi
    if ( ! sudo systemctl is-enabled --quiet mongod ); then sudo systemctl enable mongod; fi
}

function install_mongo() {
    add_mongo_repo
    update
    if ( ! sudo dpkg -s mongodb-org > /dev/null 2>&1 ); then sudo apt install -y mongodb-org ; fi
    start_mongo
}

install_mongo
