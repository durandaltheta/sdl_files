#!/bin/bash 

USAGE( )
{
    echo "-------------------"
    echo "$0 valid arguments:"
    echo "  --first_time_setup) REQUIRES: --git_user; --git_email"
    echo "  --git_user) USAGE: --git_user exampleusername"
    echo "  --git_email) USAGE: --git_email exampleemail@webserver.com"
    echo "  -i|--create_agl_image) REQUIRES: --agl_source; --platform"
    echo "  -c|--build_and_install_agl_crosssdk) REQUIRES: --agl_source; --crosssdk"
    echo "  -s|--agl_source) USAGE: --agl_source \"-b chinook -m chinook_3.0.0.xml -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo\""
    echo "  -t|--agl_target) USAGE: --agl_target \"-f -m raspberrypi3 agl-demo agl-netboot agl-appfw-smack\""
    echo "  -p|--platform) USAGE: --platform agl-demo-platform"
    echo "  -c|--crosssdk) USAGE: --crosssdk agl-demo-platform-crosssdk"
    echo "  --install_image) REQUIRES: --sdcard; --platform"
    echo "  --sdcard) USAGE: --sdcard /dev/sdb"
    echo "  --build_and_package_sdl) REQUIRES: --crosssdk"
}

ORIG_DIR=$PWD
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export AGL_TOP=$HOME/workspace_agl
cd $AGL_TOP

#set default args 
FIRST_TIME_SETUP=false 
GIT_USER=""
GIT_EMAIL=""
CREATE_AGL_IMAGE=false 
BUILD_AND_INSTALL_AGL_CROSSSDK=false
AGL_SOURCE="-b chinook -m chinook_3.0.0.xml -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo"
AGL_TARGET="-f -m raspberrypi3 agl-demo agl-netboot agl-appfw-smack"
PLATFORM="agl-demo-platform"
CROSSSDK="agl-demo-platform-crosssdk"
INSTALL_IMAGE=false
SDCARD=""
BUILD_AND_PACKAGE_SDL=false

#----------------------------
#GET INPUT ARGS
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in 
        --first_time_setup)
            FIRST_TIME_SETUP=true 
            ;;
        --git_user)
            GIT_USER=$2
            shift
            ;;
        --git_email)
            GIT_EMAIL=$2
            shift
            ;;
        -i|--create_agl_image)
            CREATE_AGL_IMAGE=true
            ;;
        -c|--build_and_install_agl_crosssdk) 
            BUILD_AND_INSTALL_AGL_CROSSSDK=true
            ;;
        -s|--agl_source)
            AGL_SOURCE="$2"
            shift
            ;;
        -t|--agl_target)
            AGL_TARGET="$2"
            shift
            ;;
        -p|--platform)
            PLATFORM="$2"
            shift
            ;;
        -c|--crosssdk)
            CROSSSDK="$2"
            shift
            ;;
        --install_image)
            INSTALL_IMAGE=true
            ;;
        --sdcard)
            SDCARD="$2"
            shift
            ;;
        --build_and_package_sdl)
            BUILD_AND_PACKAGE_SDL=true 
            ;;
        *)
            echo "Invalid argument ""$2"
            USAGE
            ;;
    esac
    shift
done


#----------------------------
# Required argument dependency checks
if [ "$FIRST_TIME_SETUP" = true ];
then 
    if [ -z "$GIT_USER" ];
    then 
        echo "ERROR: must provide your git username via --git_user [your username]"
        USAGE
        exit
    fi
    if [ -z "$GIT_EMAIL" ];
    then 
        echo "ERROR: must provide your git email via --git_user [your email]"
        USAGE
        exit
    fi 
fi  

if [ "$CREATE_AGL_IMAGE" = true ];
then 
    if [ -z "$AGL_SOURCE" ];
    then
        echo "ERROR: must provide selected agl_source via --agl_source "arguments and source url". Ex: --agl_source \"-b chinook -m chinook_3.0.0.xml -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo\""
        USAGE
        exit
    fi 
    if [ -z "$PLATFORM" ];
    then
        echo "ERROR: must provide selected platform via --platform platform-of-choice. Ex: --platform agl-demo-platform"
        USAGE
        exit
    fi 
fi 

if [ "$BUILD_AND_INSTALL_AGL_CROSSSDK" = true ];
then
    if [ -z "$AGL_SOURCE" ];
    then
        echo "ERROR: must provide selected agl_source via --agl_source "arguments and source url". Ex: --agl_source \"-b chinook -m chinook_3.0.0.xml -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo\""
        USAGE
        exit
    fi 
    if [ -z "$CROSSSDK" ];
    then 
        echo "ERROR: must provide the name of the crosssdk with --crosssdk [crosssdk name]"
        USAGE
        exit
    fi 
fi

if [ "$INSTALL_IMAGE" = true ];
then
    if [ -z "$SDCARD" ];
    then 
        echo "ERROR: must provide path to sdcard via --sdcard /path/to/sdcard/device. Ex: --sdcard /dev/sdb"
        USAGE
        exit
    fi 

    if [ -z "$PLATFORM" ];
    then
        echo "ERROR: must provide selected platform via --platform platform-of-choice. Ex: --platform agl-demo-platform"
        USAGE
        exit
    fi 
fi 

if [ "$BUILD_AND_PACKAGE_SDL" = true ];
then 
    if [ -z "$CROSSSDK" ];
    then 
        echo "ERROR: must provide the name of the crosssdk with --crosssdk [crosssdk name]"
        USAGE
        exit
    fi 
fi


#----------------------------
# SETUP AGL BUILD

# setup yocto for first time 
if [ "$FIRST_TIME_SETUP" = true ];
then 
    # install/update missing programs 
    sudo apt update
    sudo apt install make cmake gcc git vim gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev xterm cpio curl autoconf subversion
    mkdir -p $AGL_TOP
    mkdir ~/bin
    export PATH=~/bin:$PATH
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod a+x ~/bin/repo 

    git config --global user.name "$GIT_USER"
    git config --global user.email "$GIT_EMAIL"
fi

# initialize source 
if [ "$CREATE_AGL_IMAGE" = true ] || [ "$INSTALL_AGL_CROSSSDK" = true ];
then
    cd $AGL_TOP
    repo init $AGL_SOURCE 
    repo sync 
    source meta-agl/scripts/aglsetup $AGL_TARGET
fi

# build AGL image 
if [ "$CREATE_AGL_IMAGE" = true ];
then
    bitbake $PLATFORM
fi

# build and install AGL CROSSSDK
if [ "$BUILD_AND_INSTALL_AGL_CROSSSDK" = true ];
then
    bitbake $CROSSSDK 
    sudo ./tmp/deploy/sdk/share/poky-agl-glibc-x86_64-agl-demo-platform-crosssdk-cortexa15hf-neon-toolchain-3.0.0+snapshot.sh
    echo "#!/bin/bash" > $HOME/$CROSSSDK.sh 
    echo ". /opt/poky-agl/3.0.0+snapshot/environment-setup-cortexa7hf-neon-vfpv4-agl-linux-gnueabi" >> $HOME/$CROSSSDK.sh 
    chmod +x $HOME/$CROSSSDK.sh

    echo "To compile using crosssdk compiler toolchain and libraries,"
    echo "run the following command first:"
    echo "source ~/$CROSSSDK.sh"
fi

#----------------------------
#INSTALL AGL AND SETUP SDCARD 
if [ "$INSTALL_IMAGE" = true ];
then
    #umount all partitions 
    sudo umount $SDCARD?*

    #burn AGL image to sd card
    sudo dd if=tmp/deploy/images/raspberrypi3/${PLATFORM}-raspberrypi3.rpi-sdimg of=$SDCARD bs=4M 
    sync

    #add partition for free space on sd card 
    fdisk_text="$(echo -e "F\n" | sudo fdisk $SDCARD)" # get listing of empty space on the system
    freesector="$(awk 'END{print $1}')" # find starting sector of empty space
    echo -e "n\np\n\n$freesector\n\n\nw\n" | sudo fdisk $SDCARD # make new partition at empty space
    sudo mkfs -t ext4 ${SDCARD}3 # make new partition ext4 filesystem
    sudo eject $SDCARD
fi

#----------------------------
#CREATE TARBALL OF INSTALLABLES
if [ "$BUILD_AND_PACKAGE_SDL" = true ];
then 

    source $HOME/$CROSSSDK.sh
    mkdir $HOME/sdl_workspace

    # backup lib and include folders (3rd party files get written here during build)
    sudo mv /usr/local/lib /usr/local/lib_bak
    sudo mv /usr/local/include /usr/local/include_bak
    sudo mkdir -p /usr/local/lib 
    sudo mkdir -p /usr/local/include

    # clone and build SDL
    cd $HOME/sdl_workspace 
    rm -rf sdl_core/
    git clone https://github.com/pkeb/sdl_core 
    mkdir sdl_core/build
    cd sdl_core/build
    cp ../run_cmake ./ 
    ./run_cmake 
    make 
    make install 

    # clone and build bluez-tools
    cd $HOME/sdl_workspace 
    rm -rf bluez-tools
    git clone https://github.com/khvzak/bluez-tools.git 
    cd bluez-tools
    ./autogen.sh 
    ./configure 
    make 

    # checkout and build
    cd $HOME/sdl_workspace 
    rm -rf EBHMI 
    svn checkout https://swan.elektrobitautomotive.com/svn/Ford_Sync_Gen3/sandbox/sdlagl/HMI/EBHMI 
    cd EBHMI 
    qmake 
    make 
    make clean  

    # gather files for tarball
    # do housecleaning
    cd $SCRIPT_DIR 
    rm -rf sdl_installables.tar.gz 
    rm -rf sdl_installables
    mkdir -p sdl_installables/usr/local/bin 
    mkdir sdl_installables/sdl_core  

    # get scripts
    cp -rf scripts $SCRIPT_DIR/sdl_installables  

    # get systemd unit files
    cp -rf units $SCRIPT_DIR/sdl_installables  

    # get usr/local files 
    cp -rf --parents /usr/local/lib $SCRIPT_DIR/sdl_installables
    cp -rf --parents /usr/local/include $SCRIPT_DIR/sdl_installables

    #restore lib and include backups
    sudo rm -rf /usr/local/lib
    sudo rm -rf /usr/local/include
    sudo mv /usr/local/lib_bak /usr/local/lib
    sudo mv /usr/local/include_bak /usr/local/include

    # get sdl_core 
    cp -rf $HOME/sdl_workspace/sdl_core/build/bin/* $SCRIPT_DIR/sdl_installables/sdl_core 

    # get bluez-utils
    BLU_DIR=$HOME/workspace/bluez-tools/src
    cp $BLU_DIR/bt-adapter $SCRIPT_DIR/sdl_installables/usr/local/bin
    cp $BLU_DIR/bt-agent $SCRIPT_DIR/sdl_installables/usr/local/bin
    cp $BLU_DIR/bt-device $SCRIPT_DIR/sdl_installables/usr/local/bin
    cp $BLU_DIR/bt-network $SCRIPT_DIR/sdl_installables/usr/local/bin
    cp $BLU_DIR/bt-obex $SCRIPT_DIR/sdl_installables/usr/local/bin  

    # get EBHMI 
    cp -rf $HOME/sdl_workspace/EBHMI sdl_installables/ 

    # create tarball 
    cd $HOME/sdl_workspace
    tar czvf sdl_installables.tar.gz sdl_installables
fi

cd $ORIG_DIR
