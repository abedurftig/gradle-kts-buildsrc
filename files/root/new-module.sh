#!/bin/bash

[ $# -ne 2 ] && { echo "Usage: $0 <module-name> <root-package>"; exit 1; }

MODULE_NAME="$1"
ROOT_PACKAGE="$2"

mkdir $MODULE_NAME
echo "buildscript {
    repositories {
        mavenCentral()
    }
}" > "$MODULE_NAME"/build.gradle.kts

echo "rootProject.name = \"$MODULE_NAME\"" > "$MODULE_NAME"/settings.gradle.kts
echo "include(\"$MODULE_NAME\")" >> ./settings.gradle.kts

mkdir -p ./$MODULE_NAME/src/main/kotlin/$PACKAGE_DIR
mkdir -p ./$MODULE_NAME/src/main/resources
mkdir -p ./$MODULE_NAME/src/test/kotlin/$PACKAGE_DIR
