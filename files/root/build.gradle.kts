buildscript {
    repositories {
        mavenCentral()
        maven("https://plugins.gradle.org/m2/")
    }
    dependencies {
        classpath(Plugins.kotlinGradlePlugin)
    }
}

plugins {
    id("org.jetbrains.kotlin.jvm") version kotlinVersion
    id("org.jetbrains.kotlin.kapt") version kotlinVersion
    id("org.jetbrains.kotlin.plugin.allopen") version kotlinVersion
    id("com.github.johnrengelman.shadow") version "5.0.0"
    id("io.gitlab.arturbosch.detekt") version "1.0.1"
    id("org.jlleitschuh.gradle.ktlint") version "9.2.1"
    jacoco
}

allprojects {

    version = "0.0.1"
    group = "replace-me"

    repositories {
        jcenter()
        mavenCentral()
    }
}

subprojects {

    apply(plugin = "kotlin")
    apply(plugin = "kotlin-kapt")
    apply(plugin = "io.gitlab.arturbosch.detekt")
    apply(plugin = "org.jlleitschuh.gradle.ktlint")
    apply(plugin = "com.github.johnrengelman.shadow")
    apply(plugin = "jacoco")

    dependencies {

        kapt(platform("io.micronaut:micronaut-bom:$micronautVersion"))
        kapt("io.micronaut:micronaut-inject-java")
        kapt("io.micronaut:micronaut-validation")

        implementation(platform("org.jetbrains.kotlin:kotlin-bom:$kotlinVersion"))
        implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
        implementation("org.jetbrains.kotlin:kotlin-reflect")

        implementation(platform("io.micronaut:micronaut-bom:$micronautVersion"))
        implementation("io.micronaut:micronaut-runtime")
        implementation("io.micronaut:micronaut-http-server-netty")
        implementation("io.micronaut:micronaut-http-client")

        kaptTest(platform("io.micronaut:micronaut-bom:$micronautVersion"))
        kaptTest("io.micronaut:micronaut-inject-java")

        testImplementation("org.jetbrains.kotlin:kotlin-test")
        testImplementation("org.jetbrains.kotlin:kotlin-test-junit")
        testImplementation("org.junit.jupiter:junit-jupiter-api:$jupiterVersion")
        testImplementation("org.junit.jupiter:junit-jupiter-params:$jupiterVersion")
        testImplementation("org.assertj:assertj-core:3.12.2")
        testImplementation("org.mockito:mockito-core:2.28.2")
        testImplementation("com.nhaarman.mockitokotlin2:mockito-kotlin:2.1.0")
        testImplementation("io.micronaut.test:micronaut-test-junit5")

        testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:$jupiterVersion")
    }

    tasks {
        compileKotlin {
            kotlinOptions {
                jvmTarget = "1.8"
                javaParameters = true
            }
        }
        compileTestKotlin {
            kotlinOptions {
                jvmTarget = "1.8"
                javaParameters = true
            }
        }
        test {
            useJUnitPlatform()
        }
        jacocoTestReport {
            reports {
                xml.isEnabled = false
                csv.isEnabled = false
                html.isEnabled = true
                html.destination = file("$buildDir/reports/coverage")
            }
        }
        shadowJar {
            mergeServiceFiles()
        }
        check {
            dependsOn("jacocoTestReport")
        }
    }
}