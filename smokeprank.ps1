# smokeprank.ps1
# Plays a smoke-alarm low-battery chirp when a chosen key is pressed.
# Runs only while this window is open. Close it, press Ctrl+C, or
# reboot and it stops. Nothing is installed or left behind.
#
# It plays ONLY on your keypress. Every time it fires, it prints a line
# below. If you hear a sound and NO line appears here, that sound is NOT
# coming from this script (check your Bluetooth speaker reconnecting).

# ------- settings you can tweak -------
$TriggerKey = 'F8'        # the key that fires the chirp
$WavPath    = Join-Path $PSScriptRoot 'smokealarm.wav'
# --------------------------------------

Add-Type -AssemblyName System.Windows.Forms

if (-not (Test-Path $WavPath)) {
    Write-Host "ERROR: smokealarm.wav not found next to this script." -ForegroundColor Red
    Write-Host "Keep smokealarm.wav and smokeprank.ps1 in the SAME folder."
    Read-Host "Press Enter to exit"; exit 1
}

# Load the sound up front. If it can't load, we stop here with a clear
# message -- we never let .NET silently fall back to the Windows beep.
$player = New-Object System.Media.SoundPlayer $WavPath
try {
    $player.Load()
} catch {
    Write-Host "ERROR: could not load the WAV file. It may be corrupted." -ForegroundColor Red
    Write-Host $_.Exception.Message
    Read-Host "Press Enter to exit"; exit 1
}

try {
    $vk = [int][System.Windows.Forms.Keys]::$TriggerKey
} catch {
    Write-Host "'$TriggerKey' is not a valid key name. Try F8, F9, Space, etc." -ForegroundColor Red
    Read-Host "Press Enter to exit"; exit 1
}

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Keyboard {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}
"@

Write-Host ""
Write-Host "  Chirp prank is ARMED." -ForegroundColor Green
Write-Host "  Trigger key: $TriggerKey   (plays on the default output device)"
Write-Host ""
Write-Host "  Leave this window open. Close it or press Ctrl+C to stop." -ForegroundColor Yellow
Write-Host "  Each chirp I play is logged below:" -ForegroundColor DarkGray
Write-Host ""

$was_down = $false
while ($true) {
    $is_down = ([Keyboard]::GetAsyncKeyState($vk) -band 0x8000) -ne 0
    if ($is_down -and -not $was_down) {
        $player.Play()   # async; Load already succeeded so no fallback beep
        Write-Host ("  [{0:HH:mm:ss}] chirp" -f (Get-Date)) -ForegroundColor Cyan
    }
    $was_down = $is_down
    Start-Sleep -Milliseconds 30
}
