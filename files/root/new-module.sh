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

PACKAGE_DIR=$(echo $ROOT_PACKAGE | sed -e "s/\./\//g")

mkdir -p ./$MODULE_NAME/src/main/kotlin/$PACKAGE_DIR
mkdir -p ./$MODULE_NAME/src/main/resources
mkdir -p ./$MODULE_NAME/src/test/kotlin/$PACKAGE_DIR

function create_application_properties () {
    echo "micronaut:
  application:
    name: $MODULE_NAME
  server:
    port: \${PORT:\`8080\`}" > "$MODULE_NAME"/src/main/resources/application.yml
}

function create_application_class () {
    echo "package $ROOT_PACKAGE

import io.micronaut.runtime.Micronaut

object Application {

    @JvmStatic
    fun main(args: Array<String>) {
        Micronaut.build()
            .packages(\"$ROOT_PACKAGE\")
            .mainClass(Application.javaClass)
            .start()
    }
}" > "$MODULE_NAME"/src/main/kotlin/$PACKAGE_DIR/Application.kt
}

#function create_application_test () {
#
#}

function create_application () {
    echo "Creating application"
    # create application properties
    create_application_properties
    # create main class
    create_application_class
    # create application test
    create_application_test
}

if [ $MODULE_NAME == "application" ]
then
    create_application
fi

echo "Done!"
