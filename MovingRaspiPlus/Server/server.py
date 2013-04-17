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
      mcp.output(pinRightForward, 1)
      mcp.output(pinRightReverse, 0)
      # Left wheel forward
      mcp.output(pinLeftForward,  1)
      mcp.output(pinLeftReverse,  0)

    elif data == "reverse":
      # Right wheel reverse
      mcp.output(pinRightForward, 0)
      mcp.output(pinRightReverse, 1)
      # Left wheel reverse
      mcp.output(pinLeftForward,  0)
      mcp.output(pinLeftReverse,  1)

    elif data == "left":
      # Right wheel forward
      mcp.output(pinRightForward, 1)
      mcp.output(pinRightReverse, 0)
      # Left wheel reverse
      mcp.output(pinLeftForward,  0)
      mcp.output(pinLeftReverse,  1)

    elif data == "right":
      # Right wheel reverse
      mcp.output(pinRightForward, 0)
      mcp.output(pinRightReverse, 1)
      # Left wheel forward
      mcp.output(pinLeftForward,  1)
      mcp.output(pinLeftReverse,  0)

    else:
      # All wheels stop
      stop()

# Init GPIO pins    
def initPins():
    mcp.config(pinLeftForward,  mcp.OUTPUT)
    mcp.output(pinLeftForward,  0)
    mcp.config(pinLeftReverse,  mcp.OUTPUT)
    mcp.output(pinLeftReverse,  0)
    mcp.config(pinLeftEnable,   mcp.OUTPUT)
    mcp.output(pinLeftEnable,   1)

    mcp.config(pinRightForward, mcp.OUTPUT)
    mcp.output(pinRightForward, 0)
    mcp.config(pinRightReverse, mcp.OUTPUT)
    mcp.output(pinRightReverse, 0)
    mcp.config(pinRightEnable,  mcp.OUTPUT)
    mcp.output(pinRightEnable,  1)

# Set all pins to low
def stop():
    mcp.output(pinLeftForward,  0)
    mcp.output(pinLeftReverse,  0)

    mcp.output(pinRightForward, 0)
    mcp.output(pinRightReverse, 0)

# Called on process interruption. Set all pins to "low level" output.
def endProcess(signalnum = None, handler = None):
    stop()
    mcp.output(pinLeftEnable,  0)
    mcp.output(pinRightEnable, 0)
 
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

# Pins definition
pinLeftEnable  = 0
pinLeftForward = 1
pinLeftReverse = 2

pinRightEnable  = 4
pinRightForward = 5
pinRightReverse = 6

initPins()

# Init and start server
factory = Factory()
factory.protocol = MovingRaspi
reactor.listenTCP(PORT, factory, 50, IFACE)
reactor.run()
