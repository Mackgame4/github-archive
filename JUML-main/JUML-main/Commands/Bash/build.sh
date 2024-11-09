#!/bin/bash

if [ "$1" == "-dev" ]; then
    # Running in development environment
    javac -d build JUML.java
elif [ "$1" == "-prod" ]; then
    # Running in production environment
    javac -d build JUML.java
    jar cvfm JUML.jar Manifest.txt -C build .
    echo "JUML.jar created."
else
    echo "Invalid argument. Please specify either -dev or -prod."
fi