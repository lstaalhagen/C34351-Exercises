#!/bin/sh

# Check for root
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit 0
REALUSER=${SUDO_USER}
[ -z "${REALUSER}" ] && echo "Environment variable $SUDO_USER not set as expected" && exit

apt-get update
apt-get -y upgrade
apt-get -y autoremove

# Miscellaneous other packages
apt-get -y install build-essential wireshark conntrack conntrackd xterm curl \
           net-tools ssh gcc-12 bridge-utils jq nmap \
           openvswitch-common openvswitch-switch

# Cleanup apt-get
apt-get clean

# Stop/disable some irrelevant services
if [ -s Files/disablelist ] ; then
  for p in $(cat Files/disablelist) ; do
    systemctl stop ${p}
    systemctl mask ${p}
  done
fi

# Fix Grub
sed -i 's/GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/g' /etc/default/grub
sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=2/g' /etc/default/grub
update-grub

# Hack to get a better default font size in Xterm windows
XRESOURCES=/home/${REALUSER}/.Xresources
if [ -s $XRESOURCES ]; then
  grep -q -e "^xterm\*faceName:" $XRESOURCES
  if [ $? -ne 0 ]; then
    echo "xterm*faceName: Monospace" >> $XRESOURCES
    echo "xterm*faceSize: 14" >> $XRESOURCES
    sudo -u ${REALUSER} xrdb -merge $XRESOURCES
  fi
else
  echo "xterm*faceName: Monospace" > $XRESOURCES
  echo "xterm*faceSize: 14" >> $XRESOURCES
  sudo -u ${REALUSER} xrdb -merge $XRESOURCES
fi
chown ${REALUSER}: $XRESOURCES
