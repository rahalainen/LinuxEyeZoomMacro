
# LinuxEyeZoomMacro

Minecraft window zooming script for Linux users.

### Note: You should probably check out [linux-mcsr](https://its-saanvi.github.io/linux-mcsr/index.html) wiki instead!

## Usage
Clone or download the `LinuxEyeZoomMacro.sh` script and add the script as a custom keyboard shortcut.

Edit `ZOOM_HEIGHT` in the script if needed (limited to 16384 px).

(To enable logging, add `debug` as the first argument to write command output to `/tmp/LinuxEyeZoomMacro/LEZM.log`)

### KDE Plasma 6 Example
On Plasma 6, go to `System Settings` → `Keyboard` → `Shortcuts` → `Add New` → `Command or Script...` and insert the following to the prompt (modify path accordingly):
```
bash -c "<path_to_directory>/LinuxEyeZoomMacro.sh"
```

Add your shortcut, e.g. `Ctrl+J` to toggle the zoom while the Minecraft window is active.

## Requirements
Tested with KDE Plasma 6.4.2 on Arch Linux, on Wayland.

Required commands/packages:
- xorg (or xwayland)
- xdotool
- wmctrl
- xrandr

## Limitations
- Some desktop environments (e.g. GNOME) prevent windows from being resized beyond the screen edges. To work around this, drag the window slightly off-screen so the title bar is no longer visible (use Super + drag), then enter fullscreen mode and try zooming in again.
