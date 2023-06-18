#!/bin/bash

export LANG=C

cores=$(nproc --all)

# disable zram
core=0
while [ $core -lt "$cores" ]; do
    if [[ -b /dev/zram$core ]]; then
        swapoff /dev/zram$core
    fi
    (( core++ )) || true
done
if lsmod | grep -q zram ; then
    rmmod zram
fi
if [[ $1 == stop ]]; then
    exit 0
fi

# disable all
swapoff -a

# enable zram
modprobe zram num_devices="$cores"
mem=$(free | awk -v cores="$cores" '/^Mem:/{ printf "%i",($2 * 1024 / 1) }')

core=0
while [ $core -lt "$cores" ]; do
    echo lz4 > /sys/block/zram$core/comp_algorithm
    echo "$mem" > /sys/block/zram$core/disksize
    mkswap /dev/zram$core
    swapon -p 5 /dev/zram$core
    (( core++ )) || true
done
