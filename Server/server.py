from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor

from config import *
from Adafruit_MCP230xx import *

import os
import signal

# Protocol for managing MovingRaspiRemote commands
class MovingRaspi(Protocol):
  def connectionMade(self):
    # Reinit MCP access, sometimes we lost it and can't access it anymore
    mcp = None
    mcp = Adafruit_MCP230XX(address = 0x20, num_gpios = 8)
    initPins()    
    print("A client connected")

  def dataReceived(self, data):
    if data == "forward":
      # Right wheel forward
      mcp.output(0, 1)
      mcp.output(1, 1)
      # Left wheel forward
      mcp.output(4, 1)
      mcp.output(5, 1)

    elif data == "reverse":
      # Right wheel reverse
      mcp.output(2, 1)
      mcp.output(3, 1)
      # Left wheel reverse
      mcp.output(6, 1)
      mcp.output(7, 1)

    elif data == "left":
      # Right wheel forward
      mcp.output(0, 1)
      mcp.output(1, 1)
      # Left wheel reverse
      mcp.output(6, 1)
      mcp.output(7, 1)

    elif data == "right":
      # Right wheel reverse
      mcp.output(2, 1)
      mcp.output(3, 1)
      # Left wheel forward
      mcp.output(4, 1)
      mcp.output(5, 1)

    else:
      # All wheels stop
      mcp.output(0, 0)
      mcp.output(1, 0)
      mcp.output(2, 0)
      mcp.output(3, 0)
      mcp.output(4, 0)
      mcp.output(5, 0)
      mcp.output(6, 0)
      mcp.output(7, 0)


# Init GPIO pins    
def initPins():
    mcp.config(0, mcp.OUTPUT) #1, right wheel forward
    mcp.output(0, 0)
    mcp.config(1, mcp.OUTPUT) #2, right wheel forward
    mcp.output(1, 0)
    mcp.config(2, mcp.OUTPUT) #3, right wheel reverse
    mcp.output(2, 0)
    mcp.config(3, mcp.OUTPUT) #4, right wheel reverse
    mcp.output(3, 0)
    mcp.config(4, mcp.OUTPUT) #5, left wheel forward
    mcp.output(4, 0)
    mcp.config(5, mcp.OUTPUT) #6, left wheel forward
    mcp.output(5, 0)
    mcp.config(6, mcp.OUTPUT) #7, left wheel reverse 
    mcp.output(6, 0)
    mcp.config(7, mcp.OUTPUT) #8, left wheel reverse
    mcp.output(7, 0)


# Called on process interruption. Set all pins to "low level" output.
def endProcess(signalnum = None, handler = None):
    mcp.output(0, 0)
    mcp.output(1, 0)
    mcp.output(2, 0)
    mcp.output(3, 0)
    mcp.output(4, 0)
    mcp.output(5, 0)
    mcp.output(6, 0)
    mcp.output(7, 0)
    
    reactor.stop()

### Main section

# Get current pid
pid = os.getpid()

# Save current pid for later use
try:
    fhandle = open('/var/run/movingraspi.pid', 'w')
except IOError:
    print ("Unable to write /var/run/movingraspi.pid")
    exit(1)
fhandle.write(str(pid))
fhandle.close()

# Prepare handlers for process exit
signal.signal(signal.SIGTERM, endProcess)
signal.signal(signal.SIGINT, endProcess)
signal.signal(signal.SIGHUP, endProcess)

# Init MCP23008
mcp = Adafruit_MCP230XX(address = 0x20, num_gpios = 8)

initPins()

# Init and start server
factory = Factory()
factory.protocol = MovingRaspi
reactor.listenTCP(PORT, factory, 50, IFACE)
reactor.run()
