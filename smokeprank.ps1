# smokeprank.ps1
# Plays a smoke-alarm sound whenever a chosen key is pressed.
# Runs only while this window is open. Close it, press Ctrl+C, or
# reboot and it stops. Nothing is installed or left behind.

# ------- settings you can tweak -------
$TriggerKey = 'F8'        # the key that fires the alarm
$WavPath    = Join-Path $PSScriptRoot 'smokealarm.wav'
# --------------------------------------

Add-Type -AssemblyName System.Windows.Forms

if (-not (Test-Path $WavPath)) {
    Write-Host "Could not find smokealarm.wav next to this script." -ForegroundColor Red
    Write-Host "Keep smokealarm.wav and smokeprank.ps1 in the same folder."
    Read-Host "Press Enter to exit"
    exit 1
}

$player = New-Object System.Media.SoundPlayer $WavPath

# map the friendly key name to a virtual-key code
try {
    $vk = [int][System.Windows.Forms.Keys]::$TriggerKey
} catch {
    Write-Host "'$TriggerKey' is not a valid key name. Try F8, F9, Space, etc." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "  Smoke-alarm prank is ARMED." -ForegroundColor Green
Write-Host "  Trigger key: $TriggerKey"
Write-Host "  Sound plays on the default output device (point it at the Bluetooth speaker)."
Write-Host ""
Write-Host "  Leave this window open. Close it or press Ctrl+C to stop." -ForegroundColor Yellow
Write-Host ""

$was_down = $false

# GetAsyncKeyState tells us if a key is down even when another window is focused
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Keyboard {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}
"@

while ($true) {
    $state = [Keyboard]::GetAsyncKeyState($vk)
    $is_down = ($state -band 0x8000) -ne 0

    if ($is_down -and -not $was_down) {
        # fire on the press, not continuously while held
        $player.Play()   # async; won't block the loop
    }
    $was_down = $is_down

    Start-Sleep -Milliseconds 30
}
