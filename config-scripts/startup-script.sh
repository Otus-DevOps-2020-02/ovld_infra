#!/bin/bash

PACKAGES="ruby-full ruby-bundler build-essential"
FILE="/etc/apt/sources.list.d/mongodb-org-3.2.list"


#INSTALL PACKAGES FOR APP

function update() {
    echo 'Download the package lists from the repos'
    sudo apt update
    if [ $? -ne 0 ]; then
        echo "Download the package lists has failed"
        exit 1
    fi
}


function install_packages() {
    for package in $PACKAGES; do
        sudo dpkg -s $package > /dev/null 2>&1 && echo "$package is installed" || install_package $package
    done
}


function install_package() {
    echo "Installing package $1"
    sudo apt install -y $1
    if [ $? -ne 0 ]; then echo "Install package $1 failed" ; exit 1 ; fi
}

#INSTALL MONGODB

function add_mongo_repo() {
    if ( ! sudo apt-key finger|grep -q mongo ) ; then wget -qO - https://www.mongodb.org/static/pgp/server-3.2.asc | sudo apt-key add -; fi
    [ ! -f "$FILE" ] && { echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee $FILE; }
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

#DEPLOY_APP

function deploy() {
    echo "$(date +"%d-%m-%Y %I:%M:%S") Deploy App"
    cd ~
    git clone -b monolith https://github.com/express42/reddit.git
    if [ "$?" != "0" ] ; then exit 1; fi
}

function install_app() {
    if [ ! -f "/usr/local/bin/puma" ]
    then
        echo "$(date +"%d-%m-%Y %I:%M:%S") Install App"
        cd reddit && bundle install
        echo "$(date +"%d-%m-%Y %I:%M:%S") Check App and Run"
        if ( puma -V ); then puma -d; fi
        sleep 3
        echo -n "$(date +"%d-%m-%Y %I:%M:%S"): " ; echo "$(nc -vz localhost 9292)"
    else
        cd ~/reddit
        if ( puma -V ); then puma -d; fi
        sleep 3
        echo -n "$(date +"%d-%m-%Y %I:%M:%S"): " ; echo "$(nc -vz localhost 9292)"
    fi
}


update
install_packages
install_mongo
deploy
install_app
