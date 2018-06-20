@ECHO OFF
REM Description: Gets the external IP and removed unwanted characters like quotes and comas
REM Usage......: Open the CMD and run getExternalIP
REM Tip........: You can add your batch scripts folder to PATH 
REM              so you can invoke the scripts at any time from any directory

REM Get the content of ifconfig.co and extract the ip information
> %TEMP%\1 powershell (Invoke-WebRequest -Uri "ifconfig.co").Content & > %TEMP%\2 findstr /C:"ip\":" %TEMP%\1 

REM Format the output and print the formated IP address
set /p ip= < %TEMP%\2
set ipf=%ip:~9,-2%
ECHO %ipf%