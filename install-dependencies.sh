#!/bin/bash

. /etc/os-release

if [[ $NAME == "KZL Linux" ]]; then
    :
elif [[ $NAME == "Ubuntu" ]]; then
    sudo apt-get update
    sudo apt-get install -y \
        libcurl4-openssl-dev \
        libmicrohttpd-dev \
        libsqlite3-dev \
        libarchive-dev \
        texinfo \
        bison \
        flex
fi
