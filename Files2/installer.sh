#!/usr/bin/env bash

# Install script for the MQTT-CoAP-Exercise files
# (C) Copyright 2024, Lars Staalhagen, larst@dtu.dk

# Set WITHDOCS to "TRUE" if documentation for libcoap should be installed
WITHDOCS="FALSE"
if [ "${1}" = "--withdocs" ] ; then
  WITHDOCS="TRUE"
fi

# Check for root 
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit

# Download necessary supplementary software
echo "Downloading support software ... (MAY TAKE SOME TIME)"
apt-get update
apt-get -y install openvswitch-common openvswitch-switch doxygen autoconf libtool libssl-dev
if [ "${WITHDOCS}" = "TRUE" ] ; then
  apt-get -y install asciidoc exuberant-ctags
fi

#### MQTT stuff

# Download MQTT software. Note that we also disable the autostart of the broker since we want
# to do it manually in this exercise. In addition, we'll add a custom service to create a directory
# for the broker's PID-file at reboot. 
echo "Downloading MQTT software ..."
apt-get -y install mosquitto mosquitto-clients 
systemctl stop mosquitto.service
systemctl mask mosquitto.service

# Since we're not using the standard systemd service to start the broker, we'll need to create
# another service to run a boot to create the /var/run/mosquitto directory for the broker's
# PID file.
cat <<-"EOF" > /etc/systemd/system/custom-mosquitto.service
[Unit]
Description=Setup directory in /var/run for Mosquitto broker

[Service]
ExecStart=/usr/bin/mkdir -p /var/run/mosquitto
ExecStart=/usr/bin/chown mosquitto: /var/run/mosquitto
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Reload and enable service program. Create the directory manually so that the broker can
# be started without requiring a reboot.
systemctl daemon-reload
systemctl enable custom-mosquitto.service
mkdir -p /var/run/mosquitto
chmod mosquitto: /var/run/mosquitto

#### CoAP stuff

# Download/install libcoap (can take several minutes)
echo "Downloading libcoap ... (MAY TAKE SOME TIME)"
git clone https://github.com/obgm/libcoap.git
cd libcoap
./autogen.sh
if [ "${WITHDOCS}" = "TRUE" ] ; then
  ./configure --with-documentation --with-examples
else
  ./configure --disable-manpages
fi
make
make install
cd ..
rm -rf libcoap

#### Misc

# Add some stuff to root's .bashrc for namespace naming and library path for coap-programs
if ! (grep -q -e "TAG:MQTTCOAPEXERCISE" /root/.bashrc) ; then
  cat root-bashrc-addition >> /root/.bashrc
fi
