#!/bin/bash 

if [ $# -lt 2 ];
then
    echo "please provide the desired path to the sdcard device and the AGL platform like thus:"
    echo "install_image_to_sdcard.sh /path/to/sdcard your-platform"
    echo "ex:"
    echo "install_image_to_sdcard.sh /dev/sdb agl-demo-platform"
    exit
fi 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$SCRIPT_DIR/build_sdl.sh --install_image --sdcard "$1" --platform "$2" 
