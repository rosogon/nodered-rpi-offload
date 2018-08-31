#!/usr/bin/env bash
#
# Process input files and generate graphs in cwd
# Creates monitor.csv in cwd
#
# $0 <monitor.json> <jobs.json>

[ $# -lt 2 ] && echo "Usage: $0 <monitor.json> <jobs.json>" && exit 1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

MON=$1
MON_CSV=monitor.csv
JOBS=$2
JOBS_CSV=jobs.csv
TITLE=$(basename $2 .json)

jq -r '(map(keys) | add | unique) as  $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv ' < $MON > $MON_CSV
jq -r '[.[].times] | to_entries | map({index:(.key+1)} + .value) | (map(keys)|add|unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv' < $JOBS > $JOBS_CSV

START=$(jq -r '.[-1].times.batchstart' < $JOBS)
END=$(jq -r '.[-1].times.batchend' < $JOBS) # Doing nothing with it yet

NJOBS=$(echo $JOBS | sed -e 's/.*-\(.*\)-total.*/\1/' )

#
# Write summary file
#
DELTA=$(jq -r '.[-1].times.batchdelta' < $JOBS)
LOCALJOBS=$(jq -r '[.[].remote | select(. == 0)] | length' < $JOBS)
PLOCALJOBS=$(echo "scale=2; 100*$LOCALJOBS/$NJOBS" | bc)
LOCALPROCAVG=$(jq -r 'map(select(.remote == 0)) | [.[].times.procdelta] | add / length' < $JOBS)
LOCALPROCMAX=$(jq -r 'map(select(.remote == 0)) | [.[].times.procdelta] | max' < $JOBS)

cat <<EOF > summary.txt
Time: $DELTA
Total: $NJOBS
Local: $LOCALJOBS
Percentage: $PLOCALJOBS
Localprocavg: $LOCALPROCAVG
Localprocmax: $LOCALPROCMAX
EOF

#
# Start plotting
#
gnuplot -e "title='CPU usage'" -e "csv='$MON_CSV'" -e "start=$START.0" $DIR/plot1.plg > graph1.png

gnuplot -e "title='CPU frequency'" -e "csv='$MON_CSV'" -e "start=$START.0" $DIR/plot2.plg > graph2.png

gnuplot -e "title='Job completion'" -e "csv='$JOBS_CSV'" -e "njobs=$NJOBS" $DIR/plot3.plg > graph3.png

gnuplot -e "title='Job duration'" -e "csv='$JOBS_CSV'" -e "njobs=$NJOBS" $DIR/plot4.plg > graph4.png

gnuplot -e "title='Current jobs'" -e "csv='$MON_CSV'" -e "start=$START.0" -e "dir='$DIR'" $DIR/plot5.plg > graph5.png

echo $TITLE
gnuplot -e "title='$TITLE'" -e "csv='$JOBS_CSV'" -e "njobs=$NJOBS" $DIR/plot6.plg > graph6.png

montage graph2.png graph4.png -tile 2x1 -title "$TITLE" -geometry +0+0 total.png
