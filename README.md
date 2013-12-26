MovingRaspi
===========

MovingRaspi is a project about motorizing a Raspberry Pi and controlling it with an iPhone.

* [Youtube video of iPhone controls concept](http://www.youtube.com/watch?v=zaB3agbCoIY)
* [Youtube video of the final assembly](http://www.youtube.com/watch?v=nw-39-aKUKc)
* [MovingRaspi - Project's summary](http://goddess-gate.com/projects/en/raspi/movingraspi)
* [MovingRaspi - Part 1: First steps](http://goddess-gate.com/projects/en/raspi/movingraspip01)
* [MovingRaspi - Part 2: iPhone -> Raspberry Pi communication](http://goddess-gate.com/projects/en/raspi/movingraspip02)
* [MovingRaspi - Part 3: The final assembly](http://goddess-gate.com/projects/en/raspi/movingraspip03)


Differences between MovingRaspi and MovingRaspiPlus
---------------------------------------------------
* “MovingRaspi” is the “educational” version of the project. I will not evolve (except fixes for new versions of XCode / iOS), and is here to illustrate above steps.
* “MovingRaspiPlus” is the alive version of MovingRaspi. It will evolve through time, to test new concepts. Changes from MovingRaspi are :
	* Possibility to control MovingRaspi with iPhone accelerometer.
	* Use of L293D motor driver instead of “manual” H-Bridge.
    * Support for [PiCheckVoltage](https://github.com/aboudou/picheckvoltage).
	* Support for MJPEG Stream view.