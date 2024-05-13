## Simple Eye Zoom Macro for Linux users (X11)
# Author:       Rahalainen
# Version:      0.1.2
# Usage:        Bind this script to a keybind to toggle the zoom while the Minecraft window is active.
#               Run with 'debug' argument to write logs to /tmp/LinuxEyeZoomMacro.log
# Requirements: X11 environment (tested on KDE Plasma 6.0.4), xdotool, wmctrl

#!/bin/env bash

## SET SCREEN WIDTH AND HEIGHT HERE
## recommended zoom ~ 4-6x
## set BORDERLESS=1 to use borderless fullscreen (make sure to use windowed mode before toggling)
SCREEN_WIDTH=3440
SCREEN_HEIGHT=1440
ZOOM_FACTOR=4
BORDERLESS=0

# Check if the script is run with 'debug' argument
if [ "$1" = "debug" ]; then
    # Redirect output to a tmp log
    exec > /tmp/LinuxEyeZoomMacro.log 2>&1
fi

# Get active window and minecraft window IDs
ACTIVE_WINDOW=$(xdotool getwindowfocus)
MC_WINDOW=$(xdotool search --class minecraft)
echo "Active window: $ACTIVE_WINDOW"
echo "Minecraft window: $MC_WINDOW"

# Exit if Minecraft is not the active window
if [ "$ACTIVE_WINDOW" != "$MC_WINDOW" ]; then
    echo -e "\nMinecraft is not the active window! Exiting..."
    exit
fi

# Check if zooming or unzooming
eval $(xdotool getwindowgeometry --shell "$MC_WINDOW")
ZOOM_HEIGHT=$(( SCREEN_HEIGHT * ZOOM_FACTOR ))
if (( ZOOM_HEIGHT > 16384 )); then
    ZOOM_HEIGHT=16384
    echo "Zoom height capped to 16384 px."
else
    echo "Zoom height: $ZOOM_HEIGHT"
fi
echo -e "\nWindow geometry before zooming/unzooming:"
echo -e "X: $X \nY: $Y \nwidth: $WIDTH \nheight: $HEIGHT \nscreen: $SCREEN\n"

# Zoom/unzoom
if [ "$HEIGHT" = "$ZOOM_HEIGHT" ]; then
    # Minecraft is zoomed, restore the window
    echo "Unzooming to $SCREEN_WIDTH x $SCREEN_HEIGHT!"
    wmctrl -i -r "$MC_WINDOW" -e 0,0,0,"$SCREEN_WIDTH","$SCREEN_HEIGHT"
    if [ $BORDERLESS = 0 ]; then
        xdotool key F11
    fi
else
    # Minecraft is not zoomed, unfullscreen and zoom in
    echo "Zooming to $SCREEN_WIDTH x $ZOOM_HEIGHT!"
    if [ $BORDERLESS = 0 ]; then
        xdotool key F11
    fi

    # Unmaximize the window (fixes zooming on KDE) and zoom in
    wmctrl -i -r "$MC_WINDOW" -b remove,maximized_vert,maximized_horz
    wmctrl -i -r "$MC_WINDOW" -e 0,0,$(( SCREEN_HEIGHT/2 - ZOOM_HEIGHT/2 )),"$SCREEN_WIDTH","$ZOOM_HEIGHT"
fi
