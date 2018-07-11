#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <paralleljobs> <totaljobs>"
  echo "  nodered_addr default = resin.local:1880 (use ADDR env to override)"
  exit 1
fi

PARALLEL=$1
TOTAL=$2

BATCH_ID="$PARALLEL-parallel-$TOTAL-total"
ADDR=${ADDR:-http://resin.local:1880}
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
        sleep 0.1
    done
done

while [ $(get_count) -gt 0 ]; do
    sleep 1
done
