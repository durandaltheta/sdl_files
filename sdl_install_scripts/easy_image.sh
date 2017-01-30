#!/bin/bash 

./build_new_image.sh "-b chinook -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo" "-f -m raspberrypi3 agl-demo agl-netboot agl-appfw-smack agl-sota" agl-demo-platform
