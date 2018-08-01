#!/usr/bin/env bash
#
# Process input files and generate graphs in cwd
# Creates monitor.csv in cwd
#
# $0 <monitor.json> <jobs.json>

[ $# -lt 2 ] && echo "Usage: $0 <monitor.json> <jobs.json>" && exit 1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

MONITOR=$1
CSV=monitor.csv
JOBS=$2
TITLE=$(basename $2 .json)

jq -r '(map(keys) | add | unique) as  $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv ' < $1 > $CSV

START=$(jq -r '.[-1].times.batchstart' < $2)
END=$(jq -r '.[-1].times.batchend' < $2) # Doing nothing with it yet


#
# Start plotting
#
gnuplot -e "title='$TITLE'" -e "csv='$CSV'" -e "start=$START" $DIR/plot1.plg > graph1.png

# ... gnuplot -e "title='$TITLE'" -e "csv='$CSV'" -e "start='$START'" plot2.plg > graph2.png
