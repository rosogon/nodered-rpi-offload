#!/usr/bin/env bash

# Directory where results are stored
export DATA_ROOT_DIR=/tmp/data

# Directory of performance-monitor
export PERF_DIR=$HOME/projects/performance-monitor

# Architecture of docker image to start
export ARCH=armv7l
#export ARCH=x86_64

# Host to copy files from (using ssh)
export PI_HOST=resin.local
#export PI_HOST=localhost

# Address of docker daemon
DOCKER_HOST=tcp://$PI_HOST:2375
#DOCKER_HOST=

# Nodered address in gateway
export ADDR=http://$PI_HOST:1880
