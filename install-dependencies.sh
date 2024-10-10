#!/bin/bash

. /etc/os-release

if [[ $NAME == "Ubuntu" ]]; then
    sudo apt-get update
    sudo apt-get install -y \
        bison \
        flex \
        libarchive-dev \
        libcurl4-openssl-dev \
        libdebuginfod-dev \
        libgmp-dev \
        libisl-dev \
        libmicrohttpd-dev \
        libmpfr-dev \
        libsqlite3-dev \
        python-is-python3 \
        texinfo
fi
