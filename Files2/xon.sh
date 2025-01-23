#!/usr/bin/env bash 

# Check for root 
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit 1

if [ ! -d "/var/run/netns" ]; then
  echo "No namespaces. Exiting"
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "No arguments given. Usage: sudo ./xon.sh <namespace1> [<namespace2> [<namespace3> ... "
  echo "Exiting"
  exit 1
fi

while [ $# -ne 0 ]; do
  if (ls /var/run/netns | grep -q -e "^${1}$") ; then
    IPADDR=$(ip netns exec ${1} ip addr | grep "scope global" | awk '{print $2}' | cut -d'/' -f1)
    ip netns exec "${1}" xterm -title "Host ${1} (${IPADDR})" & 
  else
    echo "Error: Namespace ${1} not found."
  fi
  shift
done
