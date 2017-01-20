#!/bin/bash 

if [ $# -lt 2 ];
then
    echo "please provide the desired agl source arguments/url and the desired platform name like thus:"
    echo "build_agl_image.sh \"your source args and url\" your-platform"
    echo "ex:"
    echo "build_agl_image.sh \"-b chinook -m chinook_3.0.0.xml -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo\" agl-demo-platform"
    exit
fi 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$SCRIPT_DIR/build_sdl.sh --build_agl_image --agl_source "$1" --platform "$2" 
