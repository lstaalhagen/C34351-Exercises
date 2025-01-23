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

    # Statements that create an empty network and add a controller - DO NOT EDIT UNLESS INSTRUCTED
    net = Mininet_wifi(controller=Controller, link=wmediumd, wmediumd_mode=interference)
    c1 = net.addController('c1')

    ##################################################################################
    # ADD STATEMENTS HERE FOR THE WIRELESS DEVICES, E.G., ACCESS POINTS AND STATIONS #
    ##################################################################################
    info("*** Creating access point\n")
    ap1 = net.addAccessPoint('ap1', ssid = 'myssid', mode = 'a', channel = '36', position = '50,100,0')
    ap2 = net.addAccessPoint('ap2', ssid = 'myssid', mode = 'a', channel = '36', position = '150,100,0')
    
    info("*** Creating wireless stations\n")
    sta1 = net.addStation('sta1', ip = '192.168.0.1/24', mode = 'a', position = '50,90,0')
    # sta2 = net.addStation('sta2', ip = '192.168.0.2/24', mode = 'a', position = '110,90,0')
    
    info("*** Configuring propagation model\n")
    net.setPropagationModel(model="logDistance", exp=4.5)

    info("*** Configuring wifi nodes\n")
    net.configureNodes()
    
    # net.addLink(sta1, ap1, error_prob = 0.1)
    # net.addLink(sta2, ap1, error_prob = 0.1)
    
    ###################################################################
    # ADD STATEMENTS HERE FOR WIRED DEVICES, E.G., HOSTS AND SWITCHES #
    ###################################################################
    info("*** Creating wired hosts\n")   # Comment-out if no wired hosts
    h1 = net.addHost('h1', ip = '192.168.0.3/24')
    # h2 = net.addHost('h2', ip = '192.168.0.4/24')
    
    # info("*** Creating switches\n")   # Comment-out if no switches
    sw1 = net.addSwitch('sw1')
    
    info("*** Creating wired links\n")   # Comment-out if no wired links
    net.addLink(ap1,sw1)
    net.addLink(ap2,sw1)
    net.addLink(h1,sw1)
    
    # Create a nice plot with the APs and the STAs - wired devices are unfortunately not shown 
    if '-p' not in args:
        net.plotGraph(max_x=200, max_y=200)

    ### Simple direct trajectory
    net.startMobility(time = 0)
    net.mobility(sta1, 'start', time = 20, position = '50,90,0')
    net.mobility(sta1, 'stop',  time = 80, position = '150,90,0')
    net.stopMobility(time = 100)

    ### Random walk
    # net.startMobility(time = 0)
    # net.setMobilityModel(time = 0, model='RandomDirection', max_x=200, max_y=200, seed=20)
    # net.mobility(sta1, 'start', time = 20, position = '50,90,0')
        
    info("*** Starting network\n")
    net.build()
    c1.start()
    ap1.start([c1])
    ap2.start([c1])
    # Remember to start any switches included in the network
    sw1.start([c1])

    info("*** Running CLI\n")
    CLI(net)

    info("*** Stopping network\n")
    net.stop()


if __name__ == '__main__':
    setLogLevel('info')
    topology(sys.argv)
