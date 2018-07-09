# Offload tests #

## Quick start ##

### Cloud ###

```
cd x86_64
docker-compose up
```

Browse to $cloud_addr:1880. Import `flow_remote.json`.


### RPI ###

```
cd armv7l
export DOCKER_HOST=$rpi_addr>:2375
docker-compose up
```

Point your browser to $rpi_addr:1880. Import `flow_local.json`. Modify the cloud-link node to point to the flow in the cloud.

### Usage ###

Trigger the `start` node to test. The node injects a payload with the following properties:

* `url`: the url of the image to load
* `batchId`: a batch identifier (default: batch0)
* `thresholds` (optional): override the values on cloud-link node (e.g.: `{ "mem": 100, "cpu": 100, "temp": 80}`)

The workflow can be triggered by the HTTP endpoint `/newjob` to start a batch upload. E.g. (see submit_jobs.sh):

```
BATCH_ID=batch1
ADDR=resin.local:1880
IMG_URL=http://jurnsearch.files.wordpress.com/2009/07/ocr-test.jpg

for (( i = 0 ; i < 10 ; i++ )); do
  curl -X POST \
       -H"Content-type:application/json" \
       -d"{\"url\":\"$IMG_URL\",\"batchId\":\"$BATCH_ID\"}" \
       $ADDR/newjob
  sleep 60
done
```

Each job execution outputs an object with the times taken to execute the batch (time from the first execution of a job with a given batchId to the last execution), the process (time from when the image has been loaded to the last node) and the job (time spent in the HeavyTask flow), the offloading thresholds, the performance values by the time the job arrived and if the job was offloaded or not. The output is appended to the file `/tmp/${batchId}.json`. E.g.:

```
[
  {
    "batchId": "batch2",
    "thresholds": {
      "mem": "100",
      "cpu": "100",
      "temp": "80"
    },
    "trigger": "http",
    "times": {
      "jobstart": 1531125190896,
      "jobend": 1531125324444,
      "procstart": 1531125190815,
      "procend": 1531125324459,
      "batchstart": 1531125190815,
      "batchend": 1531125324459,
      "jobdelta": 133548,
      "procdelta": 133644,
      "batchdelta": 133644
    },
    "values": {
      "mem": 18.851716569136723,
      "cpu": 0.0384521484375,
      "temp": 53.7
    },
    "remote": 0
  },
  {
    "batchId": "batch2",
    "thresholds": {
      "mem": "100",
      "cpu": "100",
      "temp": "80"
    },
    "trigger": "http",
    "times": {
      "jobstart": 1531125200653,
      "jobend": 1531125330389,
      "procstart": 1531125200611,
      "procend": 1531125330401,
      "batchstart": 1531125190815,
      "batchend": 1531125330401,
      "jobdelta": 129736,
      "procdelta": 129790,
      "batchdelta": 139586
    },
    "values": {
      "mem": 35.41874681395163,
      "cpu": 0.071044921875,
      "temp": 60.1
    },
    "remote": 0
  }
]
```

The GET /count endpoint returns the number of jobs running at the moment, useful to know when the batch has finished.
