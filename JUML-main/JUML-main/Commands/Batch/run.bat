@echo off

if "%1" == "-dev" (
    echo Running in development environment
    REM Run "./Commands/Batch/build.bat"
    %CD%\Commands\Batch\build.bat -dev
    java -cp build JUML
) else if "%1" == "-prod" (
    echo Running in production environment
    REM Run "./Commands/Batch/build.bat"
    %CD%\Commands\Batch\build.bat -prod
    java -jar JUML.jar
) else (
    echo Invalid argument. Please specify either -dev or -prod.
)