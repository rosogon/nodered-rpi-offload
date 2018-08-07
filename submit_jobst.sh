#!/usr/bin/env bash

if [ $# -lt 4 ]; then
  echo "Usage: $0 <period> <totaljobs> <threshold-key> <threshold-value>"
  echo "  threshold-key = mem | cpu | temp | maxlocal"
  echo "  nodered_addr default = resin.local:1880 (use ADDR env to override)"
  exit 1
fi

PERIOD=$1
TOTAL=$2
KEY=$3
VALUE=$4

BATCH_ID="$PERIOD-period-$TOTAL-total-$4-$3"
ADDR=${ADDR:-http://resin.local:1880}
IMG_URL=https://github.com/desmondmorris/node-tesseract/raw/master/test/test.png
THRESHOLDS='{"mem":100,"cpu":100,"temp":100, "maxlocal": 100}'

THRESHOLDS=$(echo $THRESHOLDS | jq -c -r "setpath([\"$KEY\"];$VALUE)")

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
    sleep $PERIOD
done

while [ $(get_count) -gt 0 ]; do
    sleep 1
done
