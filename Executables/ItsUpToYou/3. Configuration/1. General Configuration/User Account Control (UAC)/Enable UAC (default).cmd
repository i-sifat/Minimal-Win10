@echo off
setlocal EnableDelayedExpansion

if /i "%~1" == "/uacSettings" goto uacSettings

whoami /user | find /i "S-1-5-18" > nul 2>&1 || (
	call RunAsTI.cmd "%~f0" "%*"
	exit /b
)

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "5" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableInstallerDetection" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableSecureUIAPaths" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableVirtualization" /t REG_DWORD /d "1" /f > nul

choice /c:yn /n /m "Would you like to have UAC not dim your desktop? You can change this in the UAC settings. [Y/N] "
if !errorlevel! == 1 (
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "1" /f > nul
)

:: Unlock UserAccountControlSettings.exe
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\UserAccountControlSettings.exe" /v "Debugger" /f > nul 2>&1

call setSvc.cmd luafv 2

echo Finished, please reboot your device for changes to apply.
pause
exit /b

:uacSettings
mode con: cols=46 lines=14
chcp 65001 > nul
echo]
echo [32m                 Enabling UAC
echo   ──────────────────────────────────────────[0m
echo   Atlas disables some services that are
echo   needed for UAC to work, and enabling UAC
echo   through the typical UAC settings will
echo   cause issues.
echo]
echo   You [1mneed to enable UAC using the Atlas
echo   script[0m to unlock the typical UAC
echo   configuration panel.
echo]
echo         [1m[33mPress any key to enable UAC...      [?25l
pause > nul
call "%~f0"
exit /b 1