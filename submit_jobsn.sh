#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <paralleljobs> <totaljobs> [<wait-metric> <wait-metric-value>]"
  echo "  nodered_addr default = resin.local:1880 (use ADDR env to override)"
  echo "  if wait-metric is specified, next job is submitted as long as "
  echo "    the <wait-metric> is below the <wait-metric-value>"
  exit 1
fi

PARALLEL=$1
TOTAL=$2
METRIC=${3:-""}
METRIC_VALUE=${4:-}

BATCH_ID="$PARALLEL-parallel-$TOTAL-total"
ADDR=${ADDR:-http://resin.local:1880}
IMG_URL=https://github.com/desmondmorris/node-tesseract/raw/master/test/test.png
THRESHOLDS='{"mem":100,"cpu":100,"temp":100}'

get_count() {
    echo $(curl -s $ADDR/count)
}

get_monitor() {
    echo $(curl -s $ADDR/monitor)
}

get_metric() {
    #m=$(echo $(get_monitor) | jq ".$METRIC" | sed -e's/\..*$//')
    #echo $m
    m=$(echo $(get_monitor) | jq ".$METRIC")
    if [[ "$m" =~ ([0-9]+)(\..*$)? ]]; then
        echo ${BASH_REMATCH[1]}
    else
        echo 0
    fi
}

for (( i = 1; i <= $TOTAL ; i++ )); do
    echo Job $i/$TOTAL
    set -x
    curl -X POST \
       -H"Content-type:application/json" \
       -d"{\"url\":\"$IMG_URL\",\"batchId\":\"$BATCH_ID\", \"thresholds\":$THRESHOLDS}" \
       $ADDR/newjob
    set +x
    count=$(get_count)
    while [[ count -ge $PARALLEL || (-n "$METRIC" && count -ge 0 && $(get_metric) -ge $METRIC_VALUE) ]]; do
        sleep 0.1
        count=$(get_count)
    done
done

while [ $(get_count) -gt 0 ]; do
    sleep 1
done
