# MQTT-CoAP-Exercise
Files for the MQTT-CoAP exercise in course 34351.

## Installation
In a terminal, execute `sudo ./installer.sh` to download and install the necessary software.

## MQTT-part of the exercise
In a terminal, execute `sudo ./netgenerate.sh` to create the virtual network and open Xterm windows on the three emulated hosts. Follow the steps in the exercise manual.

## CoAP-part exercise
In a terminal, execute `sudo ./netgenerate.sh --ipv6` to create a virtual network using IPv6 addresses and open Xterm windows on the three emulated hosts. Follow the steps in the exercise manual.

## Documentation
See the Documentation folder for:
- Powerpoint presentation about MQTT anc CoAP in general.
- Powerpoint presentation for introducing the exercises.
- Word document with the exercise guide.

## Additional remarks
If the font size is too small in the Xterm windows that open when you run the `netgenerate.sh` script, run the script `./fix-xterm-fonts.sh` from the `MQTT-CoAP-Exercise` directory. If you want to change the font size afterwards, change the value of the `xterm*faceSize:` property in the `$HOME/.Xresources` file to a suitable value and run the command `xrdb -merge $HOME/.Xresources`. Every *new* Xterm window started after this point should have the updated font size.
