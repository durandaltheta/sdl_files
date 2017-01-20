#!/bin/bash 

if [ $# -lt 2 ];
then
    echo "please provide the desired crosssdk:"
    echo "build_and_package_sdl.sh your-crosssdk"
    echo "ex:"
    echo "build_and_package_sdl.sh agl-demo-platform-crosssdk"
    exit
fi 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$SCRIPT_DIR/build_sdl.sh --build_and_package_sdl --crosssdk "$2" 
