#!/bin/bash

BATCH=pi3-201

PERIOD=5
JOBS=60
COOLDOWN=30

for i in 2 ; do

  PARAM="temp" #mem cpu temp maxlocal
#  for LIMIT in 60 65 70 75 80 ; do
  for LIMIT in 60 65 70 75 ; do
    rm -rf /tmp/offload/*.json
    ./suite_submit_jobs.sh $PERIOD $JOBS $PARAM $LIMIT $BATCH-$i
    sleep $COOLDOWN
 done

  PARAM="cpu" #mem cpu temp maxlocal
#  for LIMIT in 65 75 85 95 100 ; do
  for LIMIT in 65 75 85 95 ; do
    rm -rf /tmp/offload/*.json
    ./suite_submit_jobs.sh $PERIOD $JOBS $PARAM $LIMIT $BATCH-$i
    sleep $COOLDOWN
  done

  PARAM="maxlocal" #mem cpu temp maxlocal
  for LIMIT in 1 2 3 4 5 ; do
    rm -rf /tmp/offload/*.json
    ./suite_submit_jobs.sh $PERIOD $JOBS $PARAM $LIMIT $BATCH-$i
    sleep $COOLDOWN
  done

  PARAM="mem" #mem cpu temp maxlocal
#  for LIMIT in 65 75 85 95 100 ; do
  for LIMIT in 45 55 65 75 ; do
    rm -rf /tmp/offload/*.json
    ./suite_submit_jobs.sh $PERIOD $JOBS $PARAM $LIMIT $BATCH-$i
    sleep $COOLDOWN
  done

done
