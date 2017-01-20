#!/bin/bash

#HMI_PROC=$(cat /home/rw/sdl_core/hmi_proc)
HMI_PROC=$(pidof QmlListModel)
if [ -z $HMI_PROC ]; then
	echo "HMI SDL Demo program not running"
else
	kill $HMI_PROC
fi

nohup /home/rw/sdl_core/run_hmi.sh &
HMI_PROC=$!
echo $HMI_PROC > /home/rw/sdl_core/hmi_proc
