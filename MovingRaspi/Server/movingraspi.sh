#!/bin/sh
# 
# Start / Shutdown script for MovingRaspi
#

DIR=$(cd $(dirname "$0"); pwd)

case "$1" in
  start)

    # Start MovingRaspi
    `which python` "${DIR}"/server.py &

    ;;
  stop)
    # Stop MovingRaspi
    `which kill` -HUP `cat /var/run/movingraspi.pid`
    `which rm` /var/run/movingraspi.pid
    
    ;;

  *)
    echo "Usage: $0 {start|stop}" >&2
    exit 1

    ;;

esac

exit 0
