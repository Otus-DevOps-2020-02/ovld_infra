#!/bin/bash

FILE_SRC="/home/vld/puma.service"
FILE_DST="/etc/systemd/system/puma.service"

function init() {
    if [ -f $FILE_SRC ]
    then
        cp $FILE_SRC $FILE_DST
        chown root:root $FILE_DST
        systemctl daemon-reload
    else
        exit 1
    fi
    if ( ! systemctl is-active --quiet puma.service); then systemctl restart puma.service; fi
    if ( ! systemctl is-enabled --quiet puma.service ); then systemctl enable puma.service; fi
}

init
