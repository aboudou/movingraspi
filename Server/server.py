from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor

from config import *

import RPi.GPIO as GPIO
import os
import signal

# Protocol for managing MovingRaspiRemote commands
class MovingRaspi(Protocol):
  def connectionMade(self):
    print("A client connected")

  def dataReceived(self, data):
    if data == "forward":
      # Left wheel forward
      GPIO.output(7,  GPIO.HIGH)
      GPIO.output(11, GPIO.HIGH)
      # Right wheel forward
      GPIO.output(15, GPIO.HIGH)
      GPIO.output(16, GPIO.HIGH)

    elif data == "reverse":
      # Left wheel reverse
      GPIO.output(12, GPIO.HIGH)
      GPIO.output(13, GPIO.HIGH)
      # Right wheel reverse
      GPIO.output(18, GPIO.HIGH)
      GPIO.output(22, GPIO.HIGH)

    elif data == "left":
      # Left wheel reverse
      GPIO.output(12, GPIO.HIGH)
      GPIO.output(13, GPIO.HIGH)
      # Right wheel forward
      GPIO.output(15, GPIO.HIGH)
      GPIO.output(16, GPIO.HIGH)

    elif data == "right":
      # Left wheel forward
      GPIO.output(7,  GPIO.HIGH)
      GPIO.output(11, GPIO.HIGH)
      # Right wheel reverse
      GPIO.output(18, GPIO.HIGH)
      GPIO.output(22, GPIO.HIGH)

    else:
      # All wheels stop
      GPIO.output(7,  GPIO.LOW)
      GPIO.output(11, GPIO.LOW)
      GPIO.output(12, GPIO.LOW)
      GPIO.output(13, GPIO.LOW)
      GPIO.output(15, GPIO.LOW)
      GPIO.output(16, GPIO.LOW)
      GPIO.output(18, GPIO.LOW)
      GPIO.output(22, GPIO.LOW)


# Init GPIO pins    
def initPins():
    # TODO : replace with MCP23008 GPIO management
    GPIO.setup(7,  GPIO.OUT) #1
    GPIO.setup(11, GPIO.OUT) #2
    GPIO.setup(12, GPIO.OUT) #3
    GPIO.setup(13, GPIO.OUT) #4
    GPIO.setup(15, GPIO.OUT) #5
    GPIO.setup(16, GPIO.OUT) #6
    GPIO.setup(18, GPIO.OUT) #7
    GPIO.setup(22, GPIO.OUT) #8

# Called on process interruption. Set all pins to "Input" default mode.
def endProcess(signalnum = None, handler = None):
    # TODO : replace with MCP23008 GPIO management
    GPIO.cleanup()
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

# Use Raspberry Pi board pin numbers
# TODO : replace with MCP23008 GPIO management
GPIO.setmode(GPIO.BOARD)

initPins()

# Init and start server
factory = Factory()
factory.protocol = MovingRaspi
reactor.listenTCP(PORT, factory, 50, IFACE)
reactor.run()
