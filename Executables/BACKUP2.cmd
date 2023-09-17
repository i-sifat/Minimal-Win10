@echo off
setlocal EnableDelayedExpansion

:: Backup default Atlas services and drivers
set filename="C:\Windows\AtlasDesktop\4. Troubleshooting\Services\Default Atlas Services and Drivers.reg"
if exist "!filename!" exit /b

echo Windows Registry Editor Version 5.00 >> !filename!
for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services"') do (
	for /f "tokens=3" %%b in ('reg query "%%~a" /v "Start"') do (
		for /l %%c in (0,1,4) do (
			if "%%b"=="0x%%c" (
				echo. >> !filename!
				echo [%%~a] >> !filename!
				echo "Start"=dword:0000000%%c >> !filename!
			) 
		) 
	) 
)