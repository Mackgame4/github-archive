@echo off

echo Deleting files and directories...

if exist build\* (
    del /s /q build\* > nul
)

if exist build\ (
    rmdir /s /q build
)

if exist JUML.jar (
    del /q JUML.jar
)

echo Deletion completed.