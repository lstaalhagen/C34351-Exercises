#!/usr/bin/env bash

OMNETVER="omnetpp-6.0.2"

USERNAME=$(whoami)
HOMEDIR=$(eval echo "~${USERNAME}")

[ -d $HOMEDIR/$OMNETVER ] && cd $HOMEDIR/$OMNETVER && source setenv -q && ./bin/omnetpp
