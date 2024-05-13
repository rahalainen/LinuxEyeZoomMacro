## Simple Eye Zoom Macro for Linux users (X11)
# Author:       Rahalainen (mc, discord, github)
# Version:      0.1
# Usage:        Bind this script to a keybind shortcut to toggle the zoom whilst the Minecraft window is active.
#               Run with 'debug' argument to write logs to /tmp/LinuxEyeZoomMacro.log
# Requirements: X11 environment (tested on KDE Plasma 6.0.4), xdotool, wmctrl

#!/bin/env bash

## SET SCREEN WIDTH AND HEIGHT HERE
## recommended zoom ~ 4x
SCREEN_WIDTH=3440
SCREEN_HEIGHT=1440
ZOOM_FACTOR=4

# Check if the script is run with 'debug' argument
if [ "$1" = "debug" ]; then
    # Redirect output to a tmp log
    exec > /tmp/LinuxEyeZoomMacro.log 2>&1
fi

# Get active window and minecraft window IDs
active_window=$(xdotool getwindowfocus)
mc_window=$(xdotool search --class minecraft)
echo "Active window: $active_window"
echo "Minecraft window: $mc_window"

# Exit if Minecraft is not the active window
if [ "$active_window" != "$mc_window" ]; then
    exit
fi

# Check if zooming or unzooming
eval $(xdotool getwindowgeometry --shell "$mc_window")
echo -e "X: $X \nY: $Y \nwidth: $WIDTH \nheight: $HEIGHT \nscreen: $SCREEN"
if [ "$WIDTH" = "$SCREEN_WIDTH" ] && [ "$HEIGHT" = "$SCREEN_HEIGHT" ]; then
    # Not zoomed, unfullscreen and zoom
    xdotool key F11
    new_height=$(( SCREEN_HEIGHT * ZOOM_FACTOR ))

    # Check if height is allowed or not
    if (( $new_height > 16384 )); then
        new_height="16384"
    fi
    wmctrl -i -r "$mc_window" -e 0,0,$((-new_height/2 + SCREEN_HEIGHT/2)),"$SCREEN_WIDTH","$new_height"
else
    # Zoomed, unzoom and fullscreen
    xdotool windowsize "$mc_window" "$SCREEN_WIDTH" "$SCREEN_HEIGHT"
    xdotool key F11
fi
