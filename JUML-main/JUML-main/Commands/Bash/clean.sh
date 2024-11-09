#!/bin/bash

echo "Deleting files and directories..."

if [ -d "build" ]; then
    rm -rf build/*
    rm -rf build
fi

if [ -f "JUML.jar" ]; then
    rm -f JUML.jar
fi

echo "Deletion completed."