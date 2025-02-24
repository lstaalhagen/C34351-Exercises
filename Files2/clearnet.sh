#!/usr/bin/env bash

# Check for root 
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit

# Check and kill
[ "$TERM" = "xterm" ] && echo "Please execute script in normal terminal" && exit

pkill xterm
ip -all netns del

# Delete switches
for br in $(ovs-vsctl list-br); do
  for p in $(ovs-vsctl list-ports $br); do
    ovs-vsctl del-port $br $p
  done
  ip link set $br down
  ovs-vsctl del-br $br
done

# Namespaces
# if [ -d /var/run/netns ]; then
#   for ns in $(ls /var/run/netns); do
#    for veth in $(ip netns exec $ns ip link | grep veth | awk '{print $2}' | cut -d'@' -f1); do
#       ip netns exec $ns ip link set dev $veth down
#     done
#   done
#   for veth in $(ip link | grep veth | awk '{print $2}' | cut -d'@' -f1); do
#     ip link set dev $veth down
#     ip link del dev $veth
#   done
#   ip -all netns del
# fi    
    

