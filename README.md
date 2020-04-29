# Gradle Kotlin DSL Multi-Build with buildSrc

### Intro

A small tool to generates a Gradle multi-module build using the Koltin DSL and the `buildSrc` project.

> See [the Gradle documentation](https://docs.gradle.org/current/userguide/organizing_gradle_projects.html#sec:build_sources) for more details on the `buildSrc` project.

### Versions

- Kotlin: 1.3.72
- Gradle with wrapper: 6.3

### Usage

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
└── settings.gradle.kts
```

In this directory run `./gradlew build`.
