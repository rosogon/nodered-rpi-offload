#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <paralleljobs> [ <nodered_addr> ]"
  echo "  nodered_addr default = resin.local:1880"
  exit 1
fi

PARALLEL=$1
TOTAL=20

BATCH_ID="$PARALLEL-in-parallel"
ADDR=http://resin.local:1880
IMG_URL=https://github.com/desmondmorris/node-tesseract/raw/master/test/test.png
THRESHOLDS='{"mem":100,"cpu":100,"temp":100}'

get_count() {
    echo $(curl -s $ADDR/count)
}


for (( i = 1; i <= $TOTAL ; i++ )); do
    echo Job $i/$TOTAL
    set -x
    curl -X POST \
       -H"Content-type:application/json" \
       -d"{\"url\":\"$IMG_URL\",\"batchId\":\"$BATCH_ID\", \"thresholds\":$THRESHOLDS}" \
       $ADDR/newjob
    set +x
    while [ $(get_count) -ge $PARALLEL ]; do
        sleep 2
    done
done
