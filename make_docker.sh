#!/usr/bin/env bash
if [ ! -d node-red-contrib-tesseract ]; then
  git clone https://github.com/rosogon/node-red-contrib-tesseract.git
fi
if [ ! -d node-red-contrib-agile-deployer ]; then
  git clone https://github.com/Agile-IoT/node-red-contrib-agile-deployer.git
fi
if [ -n "$DOCKER_HOST" ]; then
  ARCH="armv7l"
  DEPLOY=resin/raspberry-pi3-node:7.8.0-slim-20170426
  BUILD=resin/raspberry-pi3-node:7.8.0-20170426
else
  ARCH="x86_64"
  DEPLOY=resin/intel-nuc-node:7.8.0-slim-20170506
  BUILD=resin/intel-nuc-node:7.8.0-20170506
fi
set -x
docker build --build-arg BASEIMAGE_DEPLOY=$DEPLOY --build-arg BASEIMAGE_BUILD=$BUILD -t rosogon/nodered-offload-$ARCH .
set +x
