#!/usr/bin/env bash

# Check for root
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit

# Hack for libssl3 version confusion (NEEDS FIXING FOR FUTURE INSTALLS)
apt-get install -y --allow-downgrades libssl3=3.0.2-0ubuntu1.12

# Install Mininet-wifi
git clone https://github.com/intrig-unicamp/mininet-wifi
cd mininet-wifi
util/install.sh -Wlnfv
cd ..
rm -rf mininet-wifi

# Cleanup apt-get
apt-get clean
