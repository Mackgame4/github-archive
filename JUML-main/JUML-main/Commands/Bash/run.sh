#!/bin/bash

if [ "$1" == "-dev" ]; then
    echo "Running in development environment"
    # Run "./Commands/Batch/build.sh"
    ./Commands/Bash/build.sh -dev
    java -cp build JUML
elif [ "$1" == "-prod" ]; then
    echo "Running in production environment"
    # Run "./Commands/Batch/build.sh"
    ./Commands/Bash/build.sh -prod
    java -jar JUML.jar
else
    echo "Invalid argument. Please specify either -dev or -prod."
fi