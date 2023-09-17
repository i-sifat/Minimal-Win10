@echo off
setlocal EnableDelayedExpansion

whoami /user | find /i "S-1-5-18" > nul 2>&1 || (
	call RunAsTI.cmd "%~f0" "%*"
	exit /b
)

goto script

----------------------------------------

[CREDITS]
- Made by he3als & Xyueta
- Repo forked from: https://github.com/he3als/setSvc

[FEATURES]
- Checking whether the service/driver exists or not, and error detection
- Can configure more services than sc.exe, sometimes there might be 'Access denied' otherwise

[USAGE]
call setSvc.cmd (service) (start)

----------------------------------------

:script
if [%~1]==[] echo You need to run this with a service/driver to disable.
if [%~2]==[] echo You need to run this with an argument ^(0-4^) to configure the service's startup. 
if %~2 LSS 0 echo Invalid start value ^(%~2^) for %~1.
if %~2 GTR 4 echo Invalid start value ^(%~2^) for %~1.

reg query "HKLM\SYSTEM\CurrentControlSet\Services\%~1" > nul 2>&1 || (
	echo The specified service/driver ^(%~1^) was not found.
	exit /b 1
)

reg add "HKLM\SYSTEM\CurrentControlSet\Services\%~1" /v "Start" /t REG_DWORD /d "%~2" /f > nul 2>&1 || (
	echo Failed to set service %~1 with start value %~2^^! Unknown error.
	exit /b 1
)