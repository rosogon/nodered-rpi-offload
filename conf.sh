#!/usr/bin/env bash

# Directory where results are stored
DATA_ROOT_DIR=/tmp/data

# Directory of performance-monitor
PERF_DIR=$HOME/projects/performance-monitor

# Architecture of docker image to start
ARCH=armv7l
#ARCH=x86_64

# Host to copy files from (using ssh)
PI_HOST=resin.local
#PI_HOST=localhost

# Address of docker daemon
DOCKER_HOST=tcp://$PI_HOST:2375
#DOCKER_HOST=

# Nodered address in gateway
ADDR=http://$PI_HOST:1880
