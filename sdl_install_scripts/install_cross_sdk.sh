#!/bin/bash 

if [ $# -lt 2 ];
then
    echo "please provide the desired agl source arguments/url and the desired platform name like thus:"
    echo "install_cross_sdk.sh \"your source args and url\" your-crosssdk"
    echo "ex:"
    echo "install_cross_sdk.sh \"-b chinook -m chinook_3.0.0.xml -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo\" agl-demo-platform"
    exit
fi 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$SCRIPT_DIR/build_sdl.sh --build_and_install_agl_crosssdk --agl_source "$1" --crosssdk "$2"
