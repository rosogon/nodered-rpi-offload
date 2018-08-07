#!/usr/bin/env bash
#
# Usage: $0 armv7l|x86_64
#

X86="x86_64"
ARM="armv7l"

ARCH=${1:-}
if [[ "$ARCH" == $X86 || "$ARCH" == $ARM ]]; then
    echo "Building $ARCH version on ${DOCKER_HOST:-localhost}"
else
    echo "Usage: $0 $X86|$ARM"
    exit 1
fi

declare -A base
base=(\
    ["$ARM"]="resin/raspberry-pi3-node:7.8.0-slim-20170426" \
    ["$X86"]="resin/intel-nuc-node:7.8.0-slim-20170506"\
)

BASE="${base[$ARCH]}"
set -x
docker build -t rosogon/nodered-offload-$ARCH --build-arg BASEIMAGE_DEPLOY=$BASE .
