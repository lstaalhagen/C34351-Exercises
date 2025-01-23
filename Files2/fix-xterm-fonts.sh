#!/usr/bin/env bash

# Script to set the default font for Xterm windows to a more reasonable font size.

# Default font and font size
DEFAULTFONT="Monospace"
DEFAULTFONTSIZE="14"

# Check that we're NOT running with sudo
[ $(id -u) -eq 0 ] && echo "Script must be executed *without* sudo" && exit

# Set or add to the .Xresources file
XRESOURCES=$HOME/.Xresources
if [ -s $XRESOURCES ] ; then
  # File .Xresources file already contains some information
  if ! (grep -q -e "^xterm\*faceName:" $XRESOURCES) ; then
    # No information for xterm
    echo "xterm*faceName: ${DEFAULTFONT}"     >> $XRESOURCES
    echo "xterm*faceSize: ${DEFAULTFONTSIZE}" >> $XRESOURCES
    xrdb -merge $XRESOURCES
  else
    echo "File ${XRESOURCES} already contains information about fonts for xterm."
    echo "Edit the file manually and run   xrdb -merge ${XRESOURCES}   afterwards."
  fi
else
  # File .Xresources doesn't exist. Create the file with the font information
  echo "xterm*faceName: ${DEFAULTFONT}"     > $XRESOURCES
  echo "xterm*faceSize: ${DEFAULTFONTSIZE}" >> $XRESOURCES
  xrdb -merge $XRESOURCES
fi
