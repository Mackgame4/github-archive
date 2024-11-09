@echo off

if "%1" == "-dev" (
    REM Running in development environment
    javac -d build JUML.java
) else if "%1" == "-prod" (
    REM Running in production environment
    javac -d build JUML.java
    jar cvfm JUML.jar Manifest.txt -C build .
    echo JUML.jar created.
) else (
    echo Invalid argument. Please specify either -dev or -prod.
)