#!/usr/bin/env python

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

    # DO NOT EDIT - Statements that create an empty network and add a controller - DO NOT EDIT
    net = Mininet_wifi(controller=Controller, link=wmediumd, wmediumd_mode=interference)
    c1 = net.addController('c1')

    # ADD STATEMENTS HERE ################################################
    info("*** Creating access point\n")

    ap1 = net.addAccessPoint("ap1", ssid = 'ssid1', mode = 'g', channel = '6', position = '100,100,0')
    
    sta1 = net.addStation("sta1", ip = "192.168.0.1/24", position = '75,100,0')
    sta2 = net.addStation("sta2", ip = "192.168.0.2/24", position = '125,100,0')    

    info("*** Configuring propagation model\n")
    net.setPropagationModel(model="logDistance", exp=4.5)

    info("*** Configuring wifi nodes\n")
    net.configureWifiNodes()

    sw1 = net.addSwitch("sw1", position = "100,125,0")

    h1 = net.addHost("h1", ip = "192.168.0.3/24", position = '80,150,0')
    h2 = net.addHost("h2", ip = "192.168.0.4/24", position = "120,150,0")

    net.addLink(ap1, sw1)
    net.addLink(sw1, h1)
    net.addLink(sw1, h2)

    if '-p' not in args:
        net.plotGraph(max_x=200, max_y=200)

    info("*** Starting network\n")
    net.build()
    c1.start()
    ap1.start([c1])
    sw1.start([c1])

    info("*** Running CLI\n")
    CLI(net)

    info("*** Stopping network\n")
    net.stop()


if __name__ == '__main__':
    setLogLevel('info')
    topology(sys.argv)
