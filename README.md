# smoke-alarm-prank

A harmless keypress prank for Windows. Press a chosen key anywhere and a
real smoke-detector low-battery chirp plays through your default audio
device (point it at a Bluetooth speaker for best effect).

## Files
- `StartPrank.bat` — double-click to arm. Close the window to stop.
- `smokeprank.ps1` — the watcher script.
- `smokealarm.wav` — the chirp sound.

## Use
1. Keep all three files in the same folder.
2. Set your Bluetooth speaker as the default playback device.
3. Double-click `StartPrank.bat`. A window opens saying "ARMED."
4. Press **F8** anywhere → one chirp plays. Press again → chirps again.

## Stop
Close the window, press Ctrl+C in it, or reboot. Nothing is installed and
nothing survives a restart.

## Change the key
Open `smokeprank.ps1` and edit the line `$TriggerKey = 'F8'`
(e.g. `'F9'`, `'Space'`, `'Scroll'`).
