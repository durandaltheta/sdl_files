#!/bin/bash 

if [ $# -lt 3 ];
then
    echo "please provide the desired agl source arguments/url and the desired platform name like thus:"
    echo "install_cross_sdk.sh \"your source args and url\" \"your_target_string\" your-crosssdk"
    echo "ex:"
    echo "install_cross_sdk.sh \"-b chinook -m chinook_3.0.0.xml -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo\" \"-f -m raspberrypi3 agl-demo agl-netboot agl-appfw-smack agl-sota\" agl-demo-platform-crosssdk"
    exit
fi 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$SCRIPT_DIR/build_sdl.sh --build_and_install_agl_crosssdk --agl_source "$1" --agl_target "$2" --crosssdk "$3"
