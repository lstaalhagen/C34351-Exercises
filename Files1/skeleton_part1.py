# *** DON'T CHANGE THE NEXT FIVE LINES
import sys
from mininet.log import setLogLevel, info
from mn_wifi.cli import CLI
from mn_wifi.net import Mininet_wifi
from mininet.link import TCLink


# Function that defines the network topology
def topology(args):

    # DO NOT EDIT - Statements that create an empty network and add a controller - DO NOT EDIT
    net = Mininet_wifi()
    c1 = net.addController('c1')

    ##################################################################################
    # ADD STATEMENTS HERE FOR THE WIRELESS DEVICES, E.G., ACCESS POINTS AND STATIONS #
    ##################################################################################
    info("*** Creating access point\n")
    # insert code here
    
    info("*** Creating wireless stations\n")
    # insert code here
    
    info("*** Configuring propagation model\n")
    net.setPropagationModel(model="logDistance", exp=4.5)

    info("*** Configuring wifi nodes\n")
    net.configureWifiNodes()

    ###################################################################
    # ADD STATEMENTS HERE FOR WIRED DEVICES, E.G., HOSTS AND SWITCHES #
    ###################################################################
    info("*** Creating wired hosts\n")   # Comment-out if no wired hosts
    # insert code here

    info("*** Creating switches\n")   # Comment-out if no switches
    # insert code here

    info("*** Creating wired links\n")   # Comment-out if no wired links
    # insert code here
	
    # Create a nice plot with the APs and the STAs - wired devices are unfortunately not shown
    if '-p' not in args:
        net.plotGraph(max_x=200, max_y=200)

    info("*** Starting network\n")
    net.build()
    c1.start()
    ap1.start([c1])
    # Remember to start any switches included in the network

    info("*** Running CLI\n")
    CLI(net)

    info("*** Stopping network\n")
    net.stop()


if __name__ == '__main__':
    setLogLevel('info')
    topology(sys.argv)
