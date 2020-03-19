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
        echo "$(date +"%d-%m-%Y %I:%M:%S") Check App and Run"
        if ( puma -V ); then puma -d; fi
        sleep 3
        echo -n "$(date +"%d-%m-%Y %I:%M:%S"): " ; echo "$(nc -vz localhost 9292)"
    else
        cd ~/reddit
        if ( puma -V ); then puma -d; fi
        sleep 3
        echo -n "$(date +"%d-%m-%Y %I:%M:%S"): " ; echo "$(nc -vz localhost 9292)"
}

deploy
install
