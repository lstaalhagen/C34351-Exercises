#!/usr/bin/env bash

# Script to create a simple virtual network for exercises in course 34351
# (C) Copyright 2024, Lars Staalhagen

# Parse command line parameters
NUMHOSTS="3"
NOXTERMS="FALSE"
IPVERSION="4"
VERBOSE="FALSE"
while [[ $# -gt 0 ]]; do
  case $1 in
    -6|--ipv6)
      IPVERSION="6"
      shift
      ;;
    -h|--help)
      HELP="TRUE"
      shift
      ;;
    -x|--noxterms)
      NOXTERMS="TRUE"
      shift
      ;;
    -n|--numhosts)
      NUMHOSTS="$2"
      shift
      shift
      ;;
    -v)
      VERBOSE="TRUE"
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

if [ -n "${HELP}" ]; then
  echo "Usage: "
  echo "   ${0} -h : Displays this message"
  echo " "
  echo "   ${0} [-x|--noxterms] [-n NUM|--numhosts NUM] [-6|--ipv6] [-v]"
  echo "      Creates virtual network with hosts connected to a switch. By default,"
  echo "      the script creates a virtual network with three hosts connected to a"
  echo "      virtual switch, assigning IPv4 addresses from the 10.0.0.0/8 address"
  echo "      range, and opens an Xterm window on each host. The behaviour may be"
  echo "      modified with the following options:"
  echo "        -x | --noxterms : Do not open Xterm windows on the hosts."
  echo "        -n | --numhosts : Create NUM (max. 254) hosts instead of three."
  echo "        -6 | --ipv6     : Assign IPv6 addresses (from the fd00::/8 range)"
  echo "                          instead of IPv4 addresses."
  echo "        -v              : Write a status message at the end of the script."
  exit
fi

# Check for root 
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit 1

# Check for terminal
[ "$TERM" = "xterm" ] && echo "Please execute script in normal terminal" && exit 1

if [ "$NUMHOSTS" -gt 254 ]; then
  echo "Error. Can not create more than 254 network namespaces. Exiting"
  exit 1
fi

# Run clearnet just to be on the safe side
[ -s ./clearnet.sh ] && . ./clearnet.sh

# Start by creating the switch
if ! (ovs-vsctl add-br S1) ; then
  echo "Failed to add switch. Aborting ..."
  exit 1
fi 

NS=1
while [ $NS -le $NUMHOSTS ]; do
  # Create a namespace for a host
  ip netns add "H${NS}"

  # Create a veth pair in the default namespace and move endpoint to host namespace
  # Naming convention: vethXY
  #    X is number of namespace
  #    Y is 1 for end-point in default namespace and 2 in specific host network namespace
  ip link add "veth${NS}1" type veth peer name "veth${NS}2"
  ip link set "veth${NS}2" netns "H${NS}"

  # Bring up veth endpoints and add address to end-point in host namespace. IP-address
  # 10.0.0.X/8 or fd00::X/ where X is the number of the host namespace
  ip netns exec "H${NS}" ip link set dev lo up
  if [ "${IPVERSION}" = "4" ]; then
    IPADDR="10.0.0.${NS}/8"
    ip netns exec "H${NS}" ip addr add $IPADDR dev "veth${NS}2"
  else
    IPADDR="fd00::${NS}/8"
    ip netns exec "H${NS}" ip addr add $IPADDR dev "veth${NS}2"
  fi
  ip netns exec "H${NS}" ip link set dev "veth${NS}2" up
  ip link set dev "veth${NS}1" up

  # Delete the IPv6 link-local address in the namespace if using IPv6, so there's only one
  # IPv6 address for the end-point.
  if [ "${IPVERSION}" = "6" ]; then
    IPLL=$(ip netns exec "H${NS}" ip addr show dev "veth${NS}2"|grep -e "inet6 fe80::"|awk '{print $2}')
    if [ -n "${IPLL}" ]; then
      ip netns exec "H${NS}" ip addr del "${IPLL}" dev "veth${NS}2"
    fi
  fi

  # Attach veth endpoint in default namespace to switch
  ovs-vsctl add-port S1 "veth${NS}1"

  # Open an xterm window on the host (conditionally)
  [ "${NOXTERMS}" = "FALSE" ] && ip netns exec "H${NS}" xterm -title "Host H${NS} ($IPADDR)" &

  NS=$(($NS + 1))
done

[ "${VERBOSE}" = "TRUE" ] && echo "Done. Virtual network with ${NUMHOSTS} hosts has been created."
