#!/bin/bash

SDL_PROC=$(pidof smartDeviceLinkCore)

if [ -z $SDL_PROC ]; then
 echo "No running SDL process"
else
 kill -9 $SDL_PROC
fi

mv /home/rw/sdl_core/bin/SmartDeviceLinkCore.log /home/rw/sdl_core/bin/SmartDeviceLinkCore.log.bak
mv /home/rw/sdl_core/bin/TransportManager.log /home/rw/sdl_core/bin/TransportManager.log.bak
mv /home/rw/sdl_core/bin/ProtocolFordHandling.log /home/rw/sdl_core/bin/ProtocolFordHandling.log.bak
nohup /home/rw/sdl_core/bin/run_sdl.sh &
