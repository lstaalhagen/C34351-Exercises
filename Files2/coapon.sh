#!/usr/bin/env bash

# Check for root 
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit 1

if [ ! -d "/var/run/netns" ]; then
  echo "No namespaces. Exiting"
  exit 1
fi

if [ $# -lt 2 ]; then
  echo "Too few arguments."
  echo "Usage: sudo ./coapon.sh <namespace> <coap-command> [<arguments>]"
  echo "  where <coap-command> is either coap-server or coap-client."
  # echo "Exiting"
  exit 1
fi

# Ensure that the LD_LIBRARY_PATH contains /usr/local/lib
if [ -z "$LD_LIBRARY_PATH" ]; then
  export LD_LIBRARY_PATH=/usr/local/lib
else
  echo $LD_LIBRARY_PATH | grep -q -E "(^|:)/usr/local/lib(:|$)"
  if [ $? -ne 0 ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
  fi
fi

ls /var/run/netns | grep -q -e "^${1}$"
[ $? -ne 0 ] && echo "Error: Namespace ${1} not found. Exiting!" && exit 1
NS="${1}"
shift

if [ "${1}" = "coap-server" -o "${1}" = "coap-client" ] ; then
  ip netns exec "${NS}" $*
else
  echo "Illegal command. Exiting"
  exit 1
fi
