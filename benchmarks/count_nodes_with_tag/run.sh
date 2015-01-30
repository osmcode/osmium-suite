#!/bin/sh
#
#  run.sh
#

if [ -z "$OB_DATA_DIR" ]; then
    echo "Please set OB_DATA_DIR environment variable to directory with OSM test data files"
    exit 1
fi

OB_RUNS=3
OB_TIME_FORMAT="b_memory=%M b_clock_time=%e b_system_time=%S b_user_time=%U b_cpu_percent=%P c_command=%C"
OB_TIME_CMD=/usr/bin/time

export PYTHONPATH=../../../pyosmium/build/lib.linux-x86_64-2.7
COMMANDS="../../../libosmium/build/benchmarks/osmium_benchmark_count_tag ./count.py ./count-handler.js ./count-stream-no-filter.js ./count-stream-filter-nodes.js ./count-stream-filter-any-key.js ./count-stream-filter-key.js ./count-stream-filter-tag.js"

OB_DATA_FILES=`find -L $OB_DATA_DIR -mindepth 1 -maxdepth 1 -type f | sort`

for data in $OB_DATA_FILES; do
    filename=`basename $data`
    filesize=`stat --format="%s" --dereference $data`
    for n in `seq 1 $OB_RUNS`; do
        for cmd in $COMMANDS; do
            $OB_TIME_CMD -f "i_filename=$filename i_filesize=$filesize n=$n $OB_TIME_FORMAT" $cmd $data 2>&1 | sed -e "s%$OB_DATA_DIR/%%" | sed -re 'N;s/\n/ /'
        done
    done
done

