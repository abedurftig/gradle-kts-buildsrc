# Gradle Kotlin DSL Multi-Module project with buildSrc

### Intro

A small tool which generates a Gradle multi-module project using the Koltin DSL and the `buildSrc` project.

> See [the Gradle documentation](https://docs.gradle.org/current/userguide/organizing_gradle_projects.html#sec:build_sources) for more details on the `buildSrc` project.

A small script is included in the generated project to quickly create and include new modules.

### Flavours

You can check out the `micronaut` branch to create a running Micronaut application.

### Versions

- Kotlin: 1.3.72 (Update in: `./files/buildSrc/Build.kt`)
- Gradle with wrapper: 6.3 (Update in: `./files/root/gradle/wrapper/gradle-wrapper.properties`)
- Micronaut: 1.3.4 (Update in: `./files/buildSrc/Build.kt`)

### Usage

#### New Project

Run `./cli dir-name`, where the last directory in `dir-name` will be the project name.

Example:

```
./cli.sh ~/development/my-project
```

Creates a project called `my-project` in `~/development/`.

The structure in the project directory will look like:
```
.
├── build.gradle.kts
├── buildSrc
│   ├── build.gradle.kts
│   └── src
│       └── main
│           └── kotlin
│               └── Build.kt
├── gradle
│   └── wrapper
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
├── gradlew
├── gradlew.bat
├── new-module.sh
└── settings.gradle.kts
```

In this directory run `./gradlew build`.

#### New Module

To create a new module run `./new-module.sh <module-name> <root-package>`. It will create a new Gradle module with `build` and `settings` file and src/test packages. Also the `settings.gradle.kts` file of the root project will be updated to include the new module.

Run `./gradlew projects` to verify it worked.

```
> Task :projects

------------------------------------------------------------
Root project
------------------------------------------------------------

Root project 'my-project'
\--- Project ':<module-name>'
```

#### New Application

To create a new application module run `./new-module.sh <module-name> <root-package> --application`, the new module will be created as a runnable `Micronaut` server application. The server will be started on port 8080 by default.

- `src/main/resources/application.yml` file is created
- `Application.kt` class is created in the root package
- `ApplicationTest.kt` class is created in the root package of the test src
- `HelloController.kt` class is created in the api package exposing the  `/hello` endpoint
- `HelloControllerTest.kt` class is created
- the `application` plugin is applied in the `build.gradle.kts` file

Run `./gradlew run` and access http://localhost:8080/hello.
