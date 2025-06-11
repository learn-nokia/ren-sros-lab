#!/bin/bash

# Define VLANs and corresponding bandwidths and lengths
declare -a vlans=(11 22 33 44 55 66)

for vlan in "${vlans[@]}"; do
    ip="192.168.$vlan.2"
    port="50$vlan"
    bw="${vlan}K"
    len=$((vlan * 10))

    echo "Starting iperf3 client to $ip:$port with $bw and packet size $len bytes"
    iperf3 -c "$ip" -p "$port" -t 600 -b "$bw" -l "$len" -u > "iperf3_vlan$vlan.log" 2>&1 &
done

echo "All iperf3 clients started in background. Logs are in iperf3_vlan<id>.log files."