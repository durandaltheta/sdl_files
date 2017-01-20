#!/bin/bash 

if [ $# -lt 2 ];
then
    echo "please provide your github username and github email like thus:"
    echo "first_time_setup.sh your_username your_email"
    exit
fi 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$SCRIPT_DIR/build_sdl.sh  --first_time_setup --git_user "$1" --git_email "$2"
