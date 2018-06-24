@ECHO OFF
REM Description: Gets the external IP and remove unwanted characters like quotes and comas
REM Usage......: getExternalIP
REM              getExternalIP <parameters>
REM Parameters.: location (Display location information for your external IP)
REM              help (Display help information)
REM Tip........: You can add your batch scripts folder to system environment variable PATH 
REM              so you can invoke the scripts at any time from any directory

SET "NEXT="
IF [%1]==[] GOTO getContent
IF ["%1"]==["location"] SET NEXT=displayLocation & GOTO getContent 
IF ["%1"]==["help"] SET NEXT=displayHelp & GOTO displayHelp

:usage
ECHO Usage: %0 ^<Parameters^>
exit /B 1

:displayHelp
ECHO Retrieves information relevant to your external IP.
ECHO.
ECHO Usage: %0 ^<Parameters^>
ECHO.
ECHO Examples:
ECHO Displays your current IP
ECHO %0
ECHO.
ECHO Display the location details for your current IP
ECHO %0 location
ECHO.
exit /B 1

:getContent
REM Get the content of ifconfig.co and extract the ip information
> %TEMP%\1 powershell (Invoke-WebRequest -Uri "ifconfig.co").Content & > %TEMP%\2 findstr /C:"ip\":" %TEMP%\1

:displayIP
REM Format the output and print the formated IP address
set /p ip= < %TEMP%\2
set ipf=%ip:~9,-2%
IF "%NEXT%" NEQ "" GOTO %NEXT%
ECHO %ipf%
exit /B 1

:displayLocation
ECHO Still in development. Coming up soon.
exit /B 1