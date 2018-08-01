#!/usr/bin/env bash
set -u

PI_HOST=${PI_HOST:-agilegw}

if [ $# -eq 0 ]; then
  echo "Usage: $0 <target-dir>"
  echo "  Assumes pi is ssh-accesible in agilegw host. Override with PI_HOST env var"
  exit 1
fi

RESULTS_DIR=$1

if [ -n "$RESULTS_DIR" ]; then
    set -x
    mkdir -p "$RESULTS_DIR" || exit 1
    scp $PI_HOST:/tmp/offload/* "$RESULTS_DIR"
    ssh $PI_HOST "sudo rm /tmp/offload/*"
    set +x
fi
