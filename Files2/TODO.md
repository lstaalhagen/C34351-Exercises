# TODO
- Fix it so that the `coap-{server|client}` programs can be executed in a number of ways:
  - Executed at the prompt of Xterm windows started on the relevant namespaces [Works currently]
  - Executed with `sudo ip netns exec <namespacename> coap-... <arguments>`
    - Requires that the LD_LIBRARY_PATH is set for the user AND propagated via sudo (sudo -E ??)
      - Or maybe set LD_LIBRARY_PATH in `/etc/bashrc` or `/etc/profile` (IS THIS ADVISABLE?)
      - Or create dedicated script (e.g., `coap-on.sh`) that user executes instead of ip netns ..., e.g., `$ sudo ./coap-on.sh H1 coap-server <arguments>`
- Reconsider the current solution with the MQTT broker, where the autostart from the installation is disabled

FIXED
=================================================================================================
- Location of the broker's PID-file was changed in the mosquitto.conf file from `/var/run/mosquitto` to `/run/mosquitto` so that the `mqtt-init.sh` script doesn't have to be exercuted after each reboot. The functionality of `mqtt-init.sh` was included in the installation script, so that the directory `/run/mosquitto` was created with the right ownership.

