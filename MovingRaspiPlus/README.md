MovingRaspiPlus
===============

MovingRaspiPlus is a project about motorizing a Raspberry Pi and controlling it with an iPhone.

The following links refer to “MovingRaspi”, the first version of the project, and the base for MovingRaspiPlus.

* [Youtube video of iPhone controls concept](http://www.youtube.com/watch?v=zaB3agbCoIY)
* [Youtube video of the final assembly](http://www.youtube.com/watch?v=nw-39-aKUKc)
* [MovingRaspi - Project's summary](http://goddess-gate.com/projects/en/raspi/movingraspi)
* [MovingRaspi - Part 1: First steps](http://goddess-gate.com/projects/en/raspi/movingraspip01)
* [MovingRaspi - Part 2: iPhone -> Raspberry Pi communication](http://goddess-gate.com/projects/en/raspi/movingraspip02)
* [MovingRaspi - Part 3: The final assembly](http://goddess-gate.com/projects/en/raspi/movingraspip03)


Requirements
------------

* First of all : a Raspberry Pi.
* Some items described [here](http://goddess-gate.com/projects/en/raspi/movingraspip01).
* For server part :
	* Python (with Debian / Raspbian : packages “python” and “python-dev”).
	* SMBus library . On Raspbian, install package “python-smbus”.
	* Twisted library. On Raspbian, install package “python-twisted”.
	* Adafruit MCP230xx library (See below).
	* Adafruit I2C library (See below).
    * (Optional) [PiCheckVoltage](https://github.com/aboudou/picheckvoltage)
* For iPhone part :
	* An iPhone (or iPad, or iPod Touch)
	* XCode 4.5.2

To help you with the assembly, you may refer to the following files :

* You may need to download and install [Raspberry Part](https://github.com/adafruit/Fritzing-Library/blob/master/AdaFruit.fzbz) for Fritzing
* MovingRaspi (L293D).fzz : the main assembly mockup (with L293D motor driver) to open with Fritzing
  ([http://fritzing.org/](http://fritzing.org/))
* Power.fzz : the example assembly for common power supply mockup to open with Fritzing
  ([http://fritzing.org/](http://fritzing.org/))


Installing Adafruit libraries
-----------------------------

Go into “Server” folder, then execute the following commands (you may need to install “curl” before) :
`curl -O https://raw.github.com/adafruit/Adafruit-Raspberry-Pi-Python-Code/master/Adafruit_I2C/Adafruit_I2C.py`
`curl -O https://raw.github.com/adafruit/Adafruit-Raspberry-Pi-Python-Code/master/Adafruit_MCP230xx/Adafruit_MCP230xx.py`

Depending on the date you got Adafruit\_MCP230xx.py, you may have a version which works with MCP23017 chip, but not with MCP23008 chip.

* If you have downloaded the file starting December 28, 2012, it will be OK.i
* If you have downloaded the file before December 27, 2012, you'll have to download it again.
* If you have downloaded the file on December 27, 2012, check at the beginning of the file for the following lines of code :

```
MCP23008_GPIOA  = 0x09
MCP23008_GPPUA  = 0x06
MCP23008_OLATA  = 0x0A
```

If they are present, you have the correct version of the file. If not, you have to download it again.

How to use MovingRaspiPlus (server)
-----------------------------------

You'll first have to build the assembly, and plug it to the Raspberry Pi.

Then update “config.py” file to fit your needs.

When you're done, just launch MovingRaspi with `./Server/movingraspi.sh start` as
  root user. When you want / need to stop it, just execute `./Server/movingraspi.sh  stop` as root user.


How to use MovingRaspiRemotePlus (iPhone)
-----------------------------------------

Just open XCode project then build and install MovingRaspiRemotePlus on your iDevice. If you don't have an Apple iOS Developper account, you may use MovingRaspiRemotePlus within iOS Simulator.

When application is started, enter hostname (or IP adress) of your Raspberry Pi, and the server port (default value is 8000, unless changed into “config.py” file). Then tap "Connect" button.

When connected to the server, you may tap on direction buttons to control motors (on final assembly) or LEDs (on test assembly).
