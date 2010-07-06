#!/usr/bin/bash

XSUN=/usr/openwin/bin/Xsun
DATE=`date '+%y%m%d.%H%M%S'`

#Check XSUN is not running
# -> tbd
PROC_PID=`ps -elf | grep -v grep | grep Xsun | awk '{ print $4}'`
if [ "$PROC_PID" == "" ]; then
  echo "XSUN Virtual Frame Buffer is not running"
else
  echo "XSUN Virtual Frame Buffer is running. Please stop it first."
  ps -fe | grep  -v grep | grep $XSUN
  exit 1
fi

#- Start the XSUN Virtual Frame Buffer
echo "Starting XSUN Virtual Frame Buffer"
nohup $XSUN :0 +nkeyboard +nmouse -dev vfb screen 0 1024x768x8 2>&1 1>/var/tmp/start_vfb.$DATE.out &
sleep 3

#Check XSUN Virtual Frame Buffer has started
# -> tbd
PROC_PID=`ps -elf | grep -v grep | grep Xsun | awk '{ print $4}'`
if [ "$PROC_PID" == "" ]; then
  echo "XSUN Virtual Frame Buffer did not start successfully ;-("
  exit 1
else
  echo "XSUN Virtual Frame Buffer start successfully !"
  ps -fe | grep  -v grep | grep $XSUN
fi

touch /var/opt/oracle/started_vfb
