Warning
=======

MovingRaspi is a work in progress and will greatly evolve as the project goes on.



MovingRaspi
===========

MovingRaspi is a project about motorizing a Raspberry Pi and controlling it with an iPhone.

* [Youtube video of iPhone controls concept](http://www.youtube.com/watch?v=zaB3agbCoIY)
* [MovingRaspi - Part 1 : First steps](https://goddess-gate.com/dc2/index.php/post/506)

Requirements
------------

* First of all : a Raspberry Pi.
* Some items described [here](https://goddess-gate.com/dc2/index.php/post/506).
* For server part :
	* Python (with Debian / Raspbian : packages “python” and “python-dev”).
	* SMBus library . On Raspbian, install package “python-smbus”.
	* Twisted library. On Raspbian, install package “python-twisted”.
	* Adafruit MCP230xx library (See below).
	* Adafruit I2C library (See below).
* For iPhone part :
	* An iPhone (or iPad, or iPod Touch)
	* XCode 4.5.2

To help you with the assembly, you may refer to the following files :

* You may need to download and install [Raspberry Part](https://github.com/adafruit/Fritzing-Library/blob/master/AdaFruit.fzbz) for Fritzing
* MovingRaspi concept.fzz : the concept assembly mockup (fire LED instead of transistors to illustrate MCP23008 use) to open with Fritzing
  ([http://fritzing.org/](http://fritzing.org/))
* MovingRaspi.fzz : the main assembly mockup to open with Fritzing
  ([http://fritzing.org/](http://fritzing.org/))
* Power.fzz : the example assembly for common power supply mockup to open with Fritzing
  ([http://fritzing.org/](http://fritzing.org/))


Installing Adafruit libraries
-----------------------------

Go into “Server” folder, then execute the following commands (you may need to install “curl” before) :
`curl -O https://raw.github.com/adafruit/Adafruit-Raspberry-Pi-Python-Code/master/Adafruit_I2C/Adafruit_I2C.py`
`curl -O https://raw.github.com/adafruit/Adafruit-Raspberry-Pi-Python-Code/master/Adafruit_MCP230xx/Adafruit_MCP230xx.py`

Depending on the date you get Adafruit\_MCP230xx.py, you may have to fix register addresses if you use an MCP23008 chip (should be OK with MCP23017 chip). You have to edit the file, and replace the code

    MCP23017_IODIRA = 0x00
    MCP23017_IODIRB = 0x01
    MCP23017_GPIOA = 0x12
    MCP23017_GPIOB = 0x13
    MCP23017_GPPUA = 0x0C
    MCP23017_GPPUB = 0x0D
    MCP23017_OLATA = 0x14
    MCP23017_OLATB = 0x15
  
with 

    MCP23017_IODIRA = 0x00
    MCP23017_IODIRB = 0x01
    MCP23017_GPIOA = 0x09
    MCP23017_GPIOB = 0x13
    MCP23017_GPPUA = 0x06
    MCP23017_GPPUB = 0x0D
    MCP23017_OLATA = 0x0A
    MCP23017_OLATB = 0x15


How to use MovingRaspi (server)
-------------------------------

You'll first have to build the assembly, and plug it to the Raspberry Pi. For now, (check [https://goddess-gate.com/dc2/index.php/pages/raspiledmeter.en](https://goddess-gate.com/dc2/index.php/pages/raspiledmeter.en) for information) for a test assembly working with the current code.

Then update “config.py” file to fit your needs.

When you're done, just launch MovingRaspi with `./Server/movingraspi.sh start` as
  root user. When you want / need to stop it, just execute `./Server/movingraspi.sh  stop` as root user.


How to use MovingRaspiRemote (iPhone)
-------------------------------------

Just open XCode project then build and install MovingRaspiRemote on your iDevice. If ypu don't have an Apple iOS Developper account, you may use MovingRaspiRemote within iOS Simulator.

When application is started, enter hostname (or IP adress) of your Raspberry Pi, and the server port (default value is 8000, unless changed into “config.py” file). Then tap "Connect" button.

When connected to the server, you may tap on direction buttons to control motors (on final assembly) or LEDs (on test assembly).
