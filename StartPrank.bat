@echo off
REM Double-click this to arm the prank. Close the window to stop it.
REM Nothing is installed; a reboot clears it automatically.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0smokeprank.ps1"
pause
