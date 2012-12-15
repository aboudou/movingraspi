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
	* RPi.GPIO library (0.4.0a or newer). On Raspbian, install package “python-rpi.gpio”.
	* Twisted library. On Raspbian, installa package “python-twisted”.
* For iPhone part :
	* An iPhone (or iPad, or iPod Touch)
	* XCode 4.5.2

To help you with the assembly, you may refer to the following files :

* You may need to download and install [Raspberry Part](https://github.com/adafruit/Fritzing-Library/blob/master/AdaFruit.fzbz) for Fritzing
* MovingRaspi.fzz : the main assembly mockup to open with Fritzing
  ([http://fritzing.org/](http://fritzing.org/))
* Power.fzz : the example assembly for common power supply mockup to open with Fritzing
  ([http://fritzing.org/](http://fritzing.org/))


How to use MovingRaspi (server)
-------------------------------

You'll first have to build the assembly, and plug it to the Raspberry Pi. For now, (check [https://goddess-gate.com/dc2/index.php/pages/raspiledmeter.en](https://goddess-gate.com/dc2/index.php/pages/raspiledmeter.en) for information) for a test assembly working with the current code.

Then update “config.py” file to fot your needs.

When you're done, just launch MovingRaspi with `./Server/movingraspi.sh start` as
  root user. When you want / need to stop it, just execute `./Server/movingraspi.sh  stop` as root user.


How to use MovingRaspiRemote (iPhone)
-------------------------------------

Just open XCode project then build and install MovingRaspiRemote on your iDevice. If ypu don't have an Apple iOS Developper account, you may use MovingRaspiRemote within iOS Simulator.

When application is started, enter hostname (or IP adress) of your Raspberry Pi, and the server port (default value is 8000, unless changed into “config.py” file). Then tap "Connect" button.

When connected to the server, you may tap on direction buttons to control motors (on final assembly) or LEDs (on test assembly).