#!/bin/bash

[ $# -eq 0 ] && { echo "Usage: $0 module-name"; exit 1; }

MODULE_NAME="$1"

mkdir $MODULE_NAME
echo "buildscript {
    repositories {
        mavenCentral()
    }
}" > "$MODULE_NAME"/build.gradle.kts

echo "rootProject.name = \"$MODULE_NAME\"" > "$MODULE_NAME"/settings.gradle.kts
echo "include(\"$MODULE_NAME\")" >> ./settings.gradle.kts