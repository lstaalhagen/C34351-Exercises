#!/usr/bin/env bash

# Check for root 
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit
REALUSER=${SUDO_USER}
[ -z "${REALUSER}" ] && echo "Environment variable $SUDO_USER not set as expected" && exit

# Install missing packages
apt-get update
apt-get -y install asciidoc

# Clone libcoap git repo and install it
git clone https://github.com/obgm/libcoap
cd libcoap
./autogen.sh
./configure --enable-examples --enable-documentation
make
make install
cd ..

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

# HACK GLOXBDITWPFR
grep -q -e "GLOXBDITWPFR" /root/.bashrc
if [ $? -ne 0 ]; then
  echo '# HACK GLOXBDITWPFR' >> /root/.bashrc
  echo 'if [ ! -z "$(ip netns identify)" ]; then' >> /root/.bashrc
  echo '  export PS1="$(ip netns identify):\w# "' >> /root/.bashrc
  echo 'fi' >> /root/.bashrc
fi

# Fix to set the LD_LIBRARY_PATH, so that the coap-server
# and coap-client programs can be run inside Xterm windows
# on namespaces. Another approach would be needed if the
# user should be able to run the programs using, e.g., with
# sudo ip netns <namespace> coap-server ...
grep -q -e "^export LD_LIBRARY_PATH=" /root/.bashrc
if [ $? -ne 0 ]; then
  echo "export LD_LIBRARY_PATH=/usr/local/lib" >> /root/.bashrc
fi

echo -e "\n\n *** Please restart the Virtual Machine *** "
