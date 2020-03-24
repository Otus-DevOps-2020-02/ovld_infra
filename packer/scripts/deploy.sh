#!/bin/bash

function deploy() {
    echo "$(date +"%d-%m-%Y %I:%M:%S") Deploy App"
    cd ~
    git clone -b monolith https://github.com/express42/reddit.git
    if [ "$?" != "0" ] ; then exit 1; fi
}

function install() {
    if [ ! -f "/usr/local/bin/puma" ]
    then
        echo "$(date +"%d-%m-%Y %I:%M:%S") Install App"
        cd reddit && bundle install
    fi
}

deploy
install
