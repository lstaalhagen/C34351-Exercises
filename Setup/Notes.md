# Notes

## Font size of Xterm windows
The general install scripts sets the fontsize of Xterm windows (for Mininet-WiFi and MQTT/CoAP) to 14 pt.
If this is too big or too small,
the user can modify the .Xresources file in the home directory and afterwards run `xrdb -merge .Xresources`
