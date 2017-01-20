#!/bin/bash

#SDL_PROC=$(cat /home/rw/sdl_core/sdl_proc)
SDL_PROC=$(pidof smartDeviceLinkCore)

#HMI_PROC=$(cat /home/rw/sdl_core/hmi_proc)
HMI_PROC=$(pidof QmlListModel)

if [ -z $SDL_PROC ]; then
 echo "No running SDL process"
else
 kill -9 $SDL_PROC
fi

if [ -z $HMI_PROC ]; then
 echo "No running HMI SDL Demo process"
else
 kill $HMI_PROC
fi
