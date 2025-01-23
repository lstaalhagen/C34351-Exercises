#!/usr/bin/env bash

# CHANGE THIS FOR DIFFERENT OMNeT++ VERSIONS
OMNETVER="omnetpp-6.0.2"

# Check for root
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit

# Save current directory for later and other stuff
CURRDIR=$(realpath .)
USERNAME=$(who am i|cut -d ' ' -f 1)   # Maybe replace with $SUDO_USER ???
HOMEDIR=$(eval echo "~$USERNAME")

# Prerequisites
apt-get -y install gdb bison flex perl swig qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
                   libqt5opengl5-dev libxml2-dev zlib1g-dev doxygen graphviz libwebkit2gtk-4.0-37 \
                   python3-pip python-is-python3 \
                   python3-scipy python3-numpy python3-matplotlib python3-pandas python3-seaborn python3-posix-ipc

# Download and install OMNeT++
URL="https://github.com/omnetpp/omnetpp/releases/download/$OMNETVER/$OMNETVER-linux-x86_64.tgz"
TGZFILE=$(basename $URL)

# Download and unpack
cd $HOMEDIR
[ -d $OMNETVER ] && rm -rf $OMNETVER
[ ! -f $TGZFILE ] && curl -LG $URL -o $TGZFILE
tar -x -f $TGZFILE -z
rm -f $TGZFILE

cd $OMNETVER
sed -i 's/WITH_OSG=yes/WITH_OSG=no/g' configure.user
sed -i 's/PREFER_CLANG=yes/PREFER_CLANG=no/g' configure.user
sed -i 's/PREFER_LLD=yes/PREFER_LLD=no/g' configure.user

# BASH=$(which bash)
# [ -z "$BASH" ] && echo "Bash must be installed" && exit
sudo -u $USERNAME -D $HOMEDIR/$OMNETVER "source setenv && ./configure && make"

# Cleanup
rm -f $HOMEDIR/.local/share/applications/$OMNETVER-ide.desktop
rm -f $HOMEDIR/.local/share/applications/$OMNETVER-shell.desktop
install -m 0755 ${CURRDIR}/Files/omnetpp.sh /usr/local/bin/omnetpp

# Cleanup apt-get
apt-get clean
