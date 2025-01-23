#!/usr/bin/env bash

# Some miscellaneous tweaks and fixes 

# Check for root
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit 0
REALUSER=${SUDO_USER}
[ -z "${REALUSER}" ] && echo "Environment variable $SUDO_USER not set as expected" && exit

# Add (real) user to sudoers file
if ! (grep -q -e "^${REALUSER}\s" /etc/sudoers) ; then
  /usr/bin/echo -e "${REALUSER}\tALL = NOPASSWD: ALL" >> /etc/sudoers
fi

# Create a directory for a shared folder and add to vboxsf group if found
if [ ! -d /home/${REALUSER}/Shared ] ; then
  mkdir -p /home/${REALUSER}/Shared
  if (getent group | grep -q -E "^vboxsf:") ; then
    usermod -aG vboxsf ${REALUSER}
  fi
fi

# Fix for VIM
for RCFILE in /home/${REALUSER}/.vimrc /root/.vimrc ; do
  if [ -f ${RCFILE} ] ; then
    sed -i 's/^set compatible$/set nocompatible/g' ${RCFILE}
  else
    echo "set nocompatible" > ${RCFILE}
  fi
done

# Fix for terminal emulator; esp. colors
if [ -f Files/terminalrc ] ; then
  if [ -f /home/user/.config/xfce4/terminal/terminalrc ] ; then
    mv /home/user/.config/xfce4/terminal/terminalrc /home/user/.config/xfce4/terminal/terminalrc.backup
  fi
  cp Files/terminalrc /home/user/.config/xfce4/terminal/
  chown user:user /home/user/.config/xfce4/terminal/terminalrc
fi
