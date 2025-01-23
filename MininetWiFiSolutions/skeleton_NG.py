#!/usr/bin/env python

# ------------------------------------------------------------------------------------
# NOTE: This skeleton file should work for both parts of the Mininet-WiFi exercise and
# should therefore be used instead of previous versions
# 20240223 - larst
# ------------------------------------------------------------------------------------

# *** DON'T CHANGE THE NEXT FIVE LINES
import sys
from mininet.node import Controller
from mininet.log import setLogLevel, info
from mn_wifi.cli import CLI
from mn_wifi.net import Mininet_wifi
from mn_wifi.link import wmediumd
from mininet.link import TCLink
from mn_wifi.wmediumdConnector import interference, error_prob

# Function that defines the network topology
def topology(args):

    # Statements that create an empty network and add a controller - DO NOT EDIT UNLESS INSTRUCTED TO
    net = Mininet_wifi(controller=Controller, link=wmediumd, wmediumd_mode=interference)
    c1 = net.addController('c1')

    ##################################################################################
    # ADD STATEMENTS HERE FOR THE WIRELESS DEVICES, E.G., ACCESS POINTS AND STATIONS #
    ##################################################################################
    info("*** Creating access point(s)\n")
    
    info("*** Creating wireless station(s)\n")
    
    info("*** Configuring propagation model\n")
    net.setPropagationModel(model="logDistance", exp=4.5)

    info("*** Configuring wifi nodes\n")
    net.configureWifiNodes()
    
    ###################################################################
    # ADD STATEMENTS HERE FOR WIRED DEVICES, E.G., HOSTS AND SWITCHES #
    ###################################################################
    info("*** Creating wired host(s)\n")   # Comment-out if no wired hosts
    
    info("*** Creating switches\n")   # Comment-out if no switches
    
    info("*** Creating wired links\n")   # Comment-out if no wired links
    
    # Create a nice plot with the APs and the STAs - wired devices are unfortunately not shown
    if '-p' not in args:
        net.plotGraph(max_x=200, max_y=200)
        
    info("*** Starting network\n")
    net.build()
    c1.start()
    ap1.start([c1])   # Repeat as necessary, if there are more than one access point in the network
    # Remember to start any switches included in the network

    info("*** Running CLI\n")
    CLI(net)

    info("*** Stopping network\n")
    net.stop()


if __name__ == '__main__':
    setLogLevel('info')
    topology(sys.argv)
