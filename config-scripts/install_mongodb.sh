#!/bin/bash

FILE="/etc/apt/sources.list.d/mongodb-org-3.2.list"

function update() {
    echo 'Update the package lists from the repos'
    apt update
    if [ $? -ne 0 ]; then
        echo "Update the package lists has failed"
        exit 1
    fi
}


function add_mongo_repo() {
    if ( ! apt-key finger|grep -q mongo ) ; then wget -qO - https://www.mongodb.org/static/pgp/server-3.2.asc | apt-key add -; fi
    [ ! -f "$FILE" ] && { echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee $FILE; }
}

function start_mongo() {
    if ( ! systemctl is-active --quiet mongod); then systemctl restart mongod; fi
    if ( ! systemctl is-enabled --quiet mongod ); then systemctl enable mongod; fi
}

function install_mongo() {
    add_mongo_repo
    update
    if ( ! dpkg -s mongodb-org > /dev/null 2>&1 ); then apt install -y mongodb-org ; fi
    start_mongo
}

install_mongo
