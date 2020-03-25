#!/bin/bash

PACKAGES="ruby-full ruby-bundler build-essential"


function update() {
    echo 'Download the package lists from the repos'
    apt-get update
    if [ $? -ne 0 ]; then
        echo "Download the package lists has failed"
        exit 1
    fi
}


function job() {
    for package in $PACKAGES; do
        dpkg -s $package > /dev/null 2>&1 && echo "$package is installed" || install $package
    done
}


function install() {
    echo "Installing package $1"
    apt-get install -y $1
    if [ $? -ne 0 ]; then echo "Install package $1 failed" ; exit 1 ; fi
}


update
job
