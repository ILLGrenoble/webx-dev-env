#!/bin/bash

if [ -r /etc/default/locale ]; then
    . /etc/default/locale
    export LANG LANGUAGE
fi

export DISPLAY=:20
export XORG_RUN_AS_USER_OK=1
export XRDP_START_WIDTH=1920
export XRDP_START_HEIGHT=1080
#export XRDP_START_WIDTH=2560
#export XRDP_START_HEIGHT=1220

FORCE_START=0
DO_STOP=0

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -d|--display)
        export DISPLAY="$2"
        shift
        shift
        ;;

        -f|--force)
        FORCE_START=1
        shift
        ;;

        -s|--stop)
        DO_STOP=1
        shift
        ;;

        -w|--width)
        XRDP_START_WIDTH="$2"
        shift
        shift
        ;;

        -h|--height)
        XRDP_START_HEIGHT="$2"
        shift
        shift
        ;;

        *)
        break
        ;;
    esac
done

xorg_proc=`ps aux | grep Xorg | grep $DISPLAY | grep -v grep | awk '{print $2}'`
if [ "$xorg_proc" != "" ]; then
    if [ $DO_STOP == 1 ]; then
        echo "Stopping Xorg running on display $DISPLAY"

        kill -9 $xorg_proc
        exit 0
    
    elif [ $FORCE_START != 1 ]; then
        echo "Xorg is already running on display $DISPLAY"
        exit 1

    elif [ $FORCE_START == 1 ]; then
        echo "Xorg is already running on display $DISPLAY: stopping current process..."
        kill -9 $xorg_proc
        sleep 3

    fi

fi

if [ $DO_STOP != 1 ]; then
    echo "Starting Xorg on display $DISPLAY with resolution ${XRDP_START_WIDTH}x${XRDP_START_HEIGHT} in the background (logs available at /tmp/xorg.log)..."
    nohup Xorg $DISPLAY -config /etc/X11/xrdp/xorg.conf -verbose > /tmp/xorg.log 2>&1 &

    sleep 3

    echo "... Starting xfce4"
    dbus-launch startxfce4

elif [ "$xorg_proc" == "" ]; then
    echo "Xorg is not running on display $DISPLAY"
fi

