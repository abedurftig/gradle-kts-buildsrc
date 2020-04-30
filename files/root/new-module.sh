#!/bin/bash

[ $# -lt 2 ] && { echo "Usage: $0 <module-name> <root-package> (--application)"; exit 1; }

MODULE_NAME="$1"
ROOT_PACKAGE="$2"
IS_APPLICATION=false

if [ $3 == "--application" ]
then
    IS_APPLICATION=true
fi

echo "Is application: $IS_APPLICATION"

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

function create_application_test () {
    echo "package $ROOT_PACKAGE

import io.micronaut.context.ApplicationContext
import io.micronaut.test.annotation.MicronautTest
import org.assertj.core.api.Assertions
import org.junit.jupiter.api.Test
import javax.inject.Inject

@MicronautTest
class ApplicationTest {

    @Inject
    private lateinit var applicationContext: ApplicationContext

    @Test
    fun sanityTest() {
        Assertions.assertThat(applicationContext.environment.activeNames).hasSize(1)
        Assertions.assertThat(applicationContext.environment.activeNames).contains(\"test\")
    }
}" > "$MODULE_NAME"/src/test/kotlin/$PACKAGE_DIR/ApplicationTest.kt
}

function create_controller_class () {
    echo "package $ROOT_PACKAGE.api

import io.micronaut.http.HttpResponse
import io.micronaut.http.annotation.Controller
import io.micronaut.http.annotation.Get

@Controller(\"/hello\")
class HelloController {

    @Get
    fun getMessage(): HttpResponse<String> {
        return HttpResponse.ok(\"Hello World!\")
    }
}" > "$MODULE_NAME"/src/main/kotlin/$PACKAGE_DIR/api/HelloController.kt
}

function create_controller_test () {
    echo "package $ROOT_PACKAGE.api

import io.micronaut.http.HttpRequest
import io.micronaut.http.client.RxHttpClient
import io.micronaut.http.client.annotation.Client
import io.micronaut.test.annotation.MicronautTest
import org.assertj.core.api.Assertions
import org.junit.jupiter.api.Test
import javax.inject.Inject

@MicronautTest
class HelloControllerTest {

    @Inject
    @field:Client(\"/hello\")
    private lateinit var httpClient: RxHttpClient

    @Test
    fun getMessage() {
        val request = HttpRequest.GET<String>(\"/\")
        val body = httpClient.toBlocking().retrieve(request)

        Assertions.assertThat(body).isEqualTo(\"Hello World!\")
    }
}" > "$MODULE_NAME"/src/test/kotlin/$PACKAGE_DIR/api/HelloControllerTest.kt
}

function create_application_build () {
    echo "buildscript {
    repositories {
        mavenCentral()
    }
}

plugins {
    application
}

application {
    mainClassName = \"$ROOT_PACKAGE.Application\"
}" > "$MODULE_NAME"/build.gradle.kts
}

function create_application () {
    echo "Creating application"

    mkdir -p ./$MODULE_NAME/src/main/kotlin/$PACKAGE_DIR/api
    mkdir -p ./$MODULE_NAME/src/test/kotlin/$PACKAGE_DIR/api

    create_application_properties
    create_application_class
    create_application_test
    create_controller_class
    create_controller_test
    create_application_build
}

if [ $IS_APPLICATION == true ]
then
    create_application
fi

echo "Done!"
