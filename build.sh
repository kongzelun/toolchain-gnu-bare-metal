#! /usr/bin/env bash
# Copyright (c) 2011-2019, ARM Limited
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Arm nor the names of its contributors may be used
#       to endorse or promote products derived from this software without
#       specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

script_path=$(cd $(dirname $0) && pwd -P)
EXECUTOR=
uname_string=`uname | sed 'y/LINUXDARWIN/linuxdarwin/'`
host_arch=`uname -m | sed 'y/XI/xi/'`

# case $uname_string in
#   "linux")
#      case $host_arch in
#        x86_64)
#          DOCKER_VAR=18.04-x86_64
#          ;;
#        aarch64)
#          DOCKER_VAR=14.04-aarch64
#          ;;
#      esac
#      echo Building docker image...
#      docker build -qt ubuntu:$DOCKER_VAR docker/$DOCKER_VAR >/dev/null
#      DOCKER="docker run -v $script_path:/build -w /build --rm ubuntu:$DOCKER_VAR"
#      EXECUTOR=${EXECUTOR:-$DOCKER}
#      ;;

#   "darwin")
#      EXECUTOR=
#      ;;
#   *)
#     echo "Unsupported build system : $uname_string" 2>&1
#     exit 1
# esac

# echo "EXECUTOR = $EXECUTOR"
# # Validate the executor
# $EXECUTOR true
# if [ 0 -ne $? ]; then
#   echo Error: Executor "$EXECUTOR" is not available to run command >&2
#   exit 1
# fi

set -e
# set -x
set -u
set -o pipefail

# $EXECUTOR ./install-sources.sh --skip_steps=mingw32 | tee install-sources.log && \
# $EXECUTOR ./build-prerequisites.sh --skip_steps=howto,mingw32,package_sources | tee build-prerequisites.log && \
# $EXECUTOR ./build-toolchain.sh --skip_steps=howto,manual,mingw32,mingw32-gdb-with-python,package_sources | tee build-toolchain.log

if [[ -f "/usr/local/bin/python3.12" ]]; then
    echo "Linking /usr/local/bin/python3.12 to python..."
    sudo ln -sf /usr/local/bin/python3.12 /usr/local/bin/python
fi

python -m pip wheel --wheel-dir ~/wheels --no-binary :all: pip wheel setuptools
python -m pip install -U --no-index --find-links ~/wheels pip wheel setuptools

echo "Installing dependencies..."
./install-dependencies.sh > install-dependencies.log 2>&1
echo "Installing sources..."
./install-sources.sh --skip_steps=mingw32 > install-sources.log 2>&1
echo "Building prerequisites..."
./build-prerequisites.sh --skip_steps=howto,mingw32,package_sources > build-prerequisites.log 2>&1
echo "Building toolchain..."
./build-toolchain.sh --skip_steps=howto,manual,mingw32,mingw32-gdb-with-python,package_sources > build-toolchain.log 2>&1

if [[ -f "/usr/local/bin/python3.12" ]]; then
    echo "Removing /usr/local/bin/python link..."
    sudo rm /usr/local/bin/python
fi
