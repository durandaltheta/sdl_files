#!/bin/bash
cd /home/rw/sdl_core/EBHMI
EBHMI=/home/rw/sdl_core/EBHMI
mv QmlListModel.log QmlListModel.log.bak
export LD_LIBRARY_PATH=$EBHMI
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$EBHMI/src
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$EBHMI/inc
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$EBHMI/img
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$EBHMI/qml 
nohup $EBHMI/QmlListModel > $EBHMI/QmlListModel.log 2>&1 &
