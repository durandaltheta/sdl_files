#!/bin/bash 

if [ $# -lt 3 ];
then
    echo "please provide the desired agl source arguments/url and the desired platform name like thus:"
    echo "build_agl_image.sh \"your source args and url\" \"your agl target string\"your-platform"
    echo "ex:"
    echo "build_new_image.sh \"-b chinook -m chinook_3.0.0.xml -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo\" \"-f -m raspberrypi3 agl-demo agl-netboot agl-appfw-smack agl-sota\" agl-demo-platform"
    exit
fi 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$SCRIPT_DIR/build_sdl.sh --build_agl_image --agl_source "$1" --agl_target "$2" --platform "$3"
