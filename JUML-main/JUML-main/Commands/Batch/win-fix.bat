@echo off

REM Prompting the user for JDK version
set /p jdk_version="Enter the JDK version (e.g., jdk-21): "
set "newPath=C:\Program Files\Java\%jdk_version%\bin"

REM Checking if the JDK version is already in the PATH
if not "%PATH%"=="%PATH:;%newPath;=%" (
    echo Path already contains %newPath%
) else (
    echo Adding %newPath% to PATH...
    setx PATH "%PATH%;%newPath%"
    echo %newPath% added to PATH.
)