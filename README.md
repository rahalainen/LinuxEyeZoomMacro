
# LinuxEyeZoomMacro

Minecraft window zooming script for Linux users.

## Usage
Clone or download the `LinuxEyeZoomMacro.sh` script and add the script as a custom keyboard shortcut.

Edit `ZOOM_FACTOR` in the script if needed (automatically limits height to 16384 px).

(To enable logging, add `debug` as the first argument to write command output to `/tmp/LinuxEyeZoomMacro/LEZM.log`)

### KDE Plasma 6 Example
On Plasma 6, go to `System Settings` → `Keyboard` → `Shortcuts` → `Add New` → `Command or Script...` and insert the following to the prompt (modify path accordingly):
```
bash -c "<path_to_directory>/LinuxEyeZoomMacro.sh"
```

Add your shortcut, e.g. `Ctrl+J` to toggle the zoom while the Minecraft window is active.

## Requirements
Tested with KDE Plasma 6.2.5 on Arch Linux, on Wayland.

Required commands/packages:
- xorg (or xwayland)
- xdotool
- wmctrl
- xrandr

## Limitations
- Original window size is lost after zooming in fullscreen mode (nonissue)
