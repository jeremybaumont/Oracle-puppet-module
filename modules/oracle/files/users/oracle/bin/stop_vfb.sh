#!/usr/bin/bash

XSUN=/usr/openwin/bin/Xsun
DATE=`date '+%y%m%d.%H%M%S'`

#Check XSUN is not running
# -> tbd
PROC_PID=`ps -elf | grep -v grep | grep Xsun | awk '{ print $4}'`
if [ "$PROC_PID" == "" ]; then
  echo "XSUN Virtual Frame Buffer is not running"
else
  echo "XSUN Virtual Frame Buffer is running. Stoppin it ..."
  kill -9 $PROC_PID > /var/tmp/stop_vfb_$DATE.out 
  if [ $? -eq 0 ]; then
        echo "XSUN Virtual Frame Buffer stopped."
        touch /var/opt/oracle/stopped_vfb
        exit 0
  else
        echo "XSUN Virtual Frame Buffer failed to be stopped ;-("
        exit 1
  fi
  
fi

