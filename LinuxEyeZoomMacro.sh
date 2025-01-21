## Simple Eye Zoom Macro for Linux users
# Author:       Rahalainen
# Version:      0.2.0
# Usage:        Bind this script to a keybind to toggle the zoom while the Minecraft window is active.
#               Run with 'debug' argument to write logs to /tmp/LinuxEyeZoomMacro.log
# Requirements: xorg/xorg-xwayland, xdotool, wmctrl, xrandr

#!/bin/env bash

## SET PROPERTIES HERE ##
ZOOM_FACTOR=4       # recommended zoom ~ 4-6x, limited to 16384px
LEZM_DIR=/tmp/LinuxEyeZoomMacro

# Check if the script is run with 'debug' argument
mkdir -p $LEZM_DIR
if [ "$1" = "debug" ]; then
    # Redirect output to a tmp log
    exec > "$LEZM_DIR/LEZM.log" 2>&1
fi

# Check if needed commands exist
commands=("xdotool wmctrl xrandr")
for command in $commands; do
    if [ ! $(command -v $command) ]; then
        echo "Command '$command' not found! Exiting..."
        exit 1
    fi
done

# Get active window and minecraft window IDs
active_window=$(xdotool getwindowfocus)
mc_window=$(xdotool search --class minecraft)
echo "Active window: $active_window"
echo "Minecraft window: $mc_window"

# Exit if Minecraft is not the active window
if [ "$active_window" != "$mc_window" ]; then
    echo -e "\nMinecraft is not the active window! Exiting..."
    exit 1
fi

# Get previous properties from the config file
PROPERTIES_FILE="$LEZM_DIR/LEZM.properties"
if [ -f "$PROPERTIES_FILE" ]; then
    echo -e "\nLoading properties file '$PROPERTIES_FILE'..."
    while IFS= read -r line; do
        # Ensure that key and value are alphanumeric (or underscores) and are separated with a '=' symbol
        if echo "$line" | grep -Eq '^(run_mode|fullscreen|maximized|original_x|original_y|original_width|original_height)=[a-zA-Z0-9_]+$'; then
            echo "Loading variable '$line'"
            declare $line
        fi
    done < "$PROPERTIES_FILE"
else
    echo "No properties file found! Creating '$PROPERTIES_FILE'..."
    run_mode="zoom"
fi

# Get monitor properties
xrandr_output=$(xrandr --query | awk '{for (i=1; i<=NF; i++) if ($i == "primary") print $(i+1)}')
monitor_width=$(echo $xrandr_output | cut -d'+' -f1 | cut -d'x' -f1)
monitor_height=$(echo $xrandr_output | cut -d'+' -f1 | cut -d'x' -f2)
monitor_x=$(echo $xrandr_output | cut -d'+' -f2)
monitor_y=$(echo $xrandr_output | cut -d'+' -f3)
echo -e "\nMonitor properties:"
echo "W: $monitor_width, H: $monitor_height, x: $monitor_x, y:$monitor_y"

# Get current window geometry
# (parse variables X, Y, WIDTH, HEIGHT and save them in lowercase)
while IFS='=' read -r key value; do
    declare "$key=$value"
done < <(xdotool getwindowgeometry --shell "$mc_window" | sed -n -E 's/^(X|Y|WIDTH|HEIGHT)=([0-9]+)/\L\1=\2/p')
echo -e "\nWindow properties:"
echo -e "W: $width, H: $height, x: $x, y:$y\n"



# Determine zoom amount
zoom_height=$(( monitor_height * ZOOM_FACTOR ))
if (( zoom_height > 16384 )); then
    zoom_height=16384
    echo "Zoom height capped to 16384 px."
else
    echo "Zoom height: $zoom_height"
fi

# Zooming/unzooming
if [ "$run_mode" = "zoom" ]; then
    # Check for fullscreen mode
    if [[ "$monitor_width" = "$width" ]] && [[ "$monitor_height" = "$height" ]]; then
        fullscreen=1
        xdotool key F11
    else
        fullscreen=0
    fi

    # Check for maximized mode
    maximized_status=$(xprop -id "$mc_window" | grep "_NET_WM_STATE(ATOM)")
    if echo "$maximized_status" | grep -q "_NET_WM_STATE_MAXIMIZED_VERT" && echo "$maximized_status" | grep -q "_NET_WM_STATE_MAXIMIZED_HORZ"; then
        maximized=1
        wmctrl -i -r "$mc_window" -b remove,maximized_vert,maximized_horz
    else
        maximized=0
    fi

    # Zoom in
    printf "Zooming to %ix%i!\n" "$monitor_width" "$zoom_height"
    echo "Fullscreen: $fullscreen, maximized: $maximized"
    original_x="$x"
    original_y="$y"
    original_width="$width"
    original_height="$height"
    run_mode="unzoom"

    wmctrl -i -r "$mc_window" -e 0,"$monitor_x",$(( monitor_height/2 - zoom_height/2 )),"$monitor_width","$zoom_height"
elif [ "$run_mode" = "unzoom" ]; then
    printf "Unzooming to %ix%i!\n" "$original_width" "$original_height"
    echo "Fullscreen: $fullscreen, maximized: $maximized"
    run_mode="zoom"
    wmctrl -i -r "$mc_window" -e 0,"$original_x","$original_y","$original_width","$original_height"

    # Maximize the window
    if [ "$maximized" == 1 ]; then
        wmctrl -i -r "$mc_window" -b add,maximized_vert,maximized_horz
    fi

    # Fullscreen the window
    if [ "$fullscreen" == 1 ]; then
        xdotool key F11
    fi
else
    echo -e "\nInvalid run mode '$run_mode'! Setting to 'zoom' and exiting..."
    run_mode="zoom"
fi

# Write new properties to the properties file
> $PROPERTIES_FILE
properties_vars=("run_mode fullscreen maximized original_x original_y original_width original_height")
for key in $properties_vars; do
    value="${!key}"
    printf '%s=%s\n' "$key" "$value" >> "$PROPERTIES_FILE"
done
exit 0
