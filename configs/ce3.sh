#!/bin/bash
vlans=(11 22 33 44 55 66)
IFACE="eth1"
for vlan in "${vlans[@]}"; do
    ip link add link "$IFACE" name "$IFACE.$vlan" type vlan id "$vlan"
    ip link set dev "$IFACE.$vlan" up
    ip addr add 192.168.$vlan.2/24 dev "$IFACE.$vlan"
    iperf3 -s -B 192.168.$vlan.2 -p 50$vlan -D &
done
