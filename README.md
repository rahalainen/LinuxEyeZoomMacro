
# LinuxEyeZoomMacro

Minecraft window zooming script for X11 Linux users.
## Usage
Clone or download the `LinuxEyeZoomMacro.sh` script and add the script as a custom keyboard shortcut.

Edit `SCREEN_WIDTH` and `SCREEN_HEIGHT` in the script according to your screen's resolution. Modify the zoom factor (limited to 16384 px) if needed.

### KDE Plasma 6 Example
On Plasma 6, go to `System Settings` → `Keyboard` → `Shortcuts` → `Add New` → `Command or Script...` and insert the following to the prompt (modify path accordingly):
```
bash <path_to_directory>/LinuxEyeZoomMacro.sh
```
(To enable logging, add `debug` as an argument to write command output to `/tmp/LinuxEyeZoomMacro.log`)

Add your shortcut, e.g. `Ctrl+J` to toggle the zoom while the Minecraft window is active.
## Requirements
Tested with KDE Plasma 6.0.4 on Arch Linux, on X11.
Required commands/packages:
- xorg
- xdotool
- wmctrl
## Limitations
- Only works on X11, hasn't been tested with Wayland
- Script toggles fullscreen, no implementation for maximized windows
