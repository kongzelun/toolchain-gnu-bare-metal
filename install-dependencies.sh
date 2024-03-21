#!/bin/bash

. /etc/os-release

if [[ $NAME == "KZL Linux" ]]; then
    :
elif [[ $NAME == "Ubuntu" ]]; then
    sudo apt-get update
    sudo apt-get install -y \
        libmicrohttpd-dev \
        libsqlite3-dev \
        texinfo \
        bison \
        flex \
        python-is-python3
fi
