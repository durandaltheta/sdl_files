#!/bin/bash

if [ -z $1 ]
then
	continue
else
	sleep $1
fi

mv /home/rw/sdl_core/bin/SmartDeviceLinkCore.log /home/rw/sdl_core/bin/SmartDeviceLinkCore.log.bak
mv /home/rw/sdl_core/bin/TransportManager.log /home/rw/sdl_core/bin/TransportManager.log.bak
mv /home/rw/sdl_core/bin/ProtocolFordHandling.log /home/rw/sdl_core/bin/ProtocolFordHandling.log.bak
nohup /home/rw/sdl_core/bin/run_sdl.sh &

nohup /home/rw/sdl_core/run_hmi.sh &
