#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <batchId> [ <nodered_addr> ]"
  echo "  nodered_addr default = resin.local:1880"
  exit 1
fi

BATCH_ID=$1
ADDR=${2:-resin.local:1880}
IMG_URL=http://jurnsearch.files.wordpress.com/2009/07/ocr-test.jpg

for (( i = 0 ; i < 2 ; i++ )); do
  curl -X POST \
       -H"Content-type:application/json" \
       -d"{\"url\":\"$IMG_URL\",\"batchId\":\"$BATCH_ID\"}" \
       $ADDR/newjob
  sleep 10
done
