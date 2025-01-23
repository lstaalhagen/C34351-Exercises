#!/usr/bin/env bash 

# Check for root 
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit 1

if [ ! -d "/var/run/netns" ]; then
  echo "No namespaces. Exiting"
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "No arguments given. Usage: sudo ./xon.sh <namespace>"
  echo "Exiting"
  exit 1
fi

while [ $# -ne 0 ]; do
  FOUND="FALSE"
  for NS in $(ls /var/run/netns); do
    if [ "${NS}" = "${1}" ]; then
      FOUND="TRUE"
      IPADDR=$(ip netns exec ${NS} ip addr | grep "scope global" | awk '{print $2}' | cut -d'/' -f1)
      ip netns exec "${NS}" xterm -title "Host ${NS} (${IPADDR})" & 
    fi
  done
  if [ "${FOUND}" = "FALSE" ]; then
    echo "Error: Namespace ${1} not found. Exiting"
    exit 1
  fi
  shift
done
