/*
 * This file was generated by the Gradle 'init' task.
 *
 * This generated file contains a sample Java project to get you started.
 * For more details take a look at the Java Quickstart chapter in the Gradle
 * User Manual available at https://docs.gradle.org/5.5.1/userguide/tutorial_java_projects.html
 */

import org.gradle.jvm.tasks.Jar

plugins {
    // Apply the java plugin to add support for Java
    java

    // Apply the application plugin to add support for building a CLI application
    application

    // Intellij IDEA
    idea
}

repositories {
    // Use jcenter for resolving dependencies.
    // You can declare any Maven/Ivy/file repository here.
    jcenter()
}

dependencies {
    // This dependency is used by the application.
//    implementation("com.google.guava:guava:27.1-jre")
//
//    compile(group = "org.apache.logging.log4j", name = "log4j-core", version = "1.12.17")
    compile(group = "org.apache.logging.log4j", name = "log4j-core", version = "2.12.0")
    compile(group = "org.apache.logging.log4j", name = "log4j-api", version = "2.12.0")

    // Use JUnit test framework
    testImplementation("junit:junit:4.12")
}

application {
    // Define the main class for the application
    mainClassName = "dummy.process.App"
}

val fatJar = task("fatJar", type = Jar::class) {
    baseName = "${project.name}-fat"
    manifest {
        attributes["Implementation-Title"] = "Gradle Jar File Example"
//        attributes["Implementation-Version"] = version
        attributes["Main-Class"] = "dummy.process.App"
    }
    from(configurations.runtimeClasspath.get().map({ if (it.isDirectory) it else zipTree(it) }))
    with(tasks.jar.get() as CopySpec)
}

tasks {
    "build" {
        dependsOn(fatJar)
    }
}