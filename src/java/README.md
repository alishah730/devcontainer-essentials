
# java from devcontainer-essentials (java)

Install Java Development Kit with support for OpenJDK and Eclipse Temurin distributions. Includes optional Apache Maven and Gradle build tools. Supports Java versions 8, 11, 16, 17, 21, and latest with automatic JAVA_HOME configuration.

## Example Usage

```json
"features": {
    "ghcr.io/alishah730/devcontainer-essentials/java:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select Java version: 8 (legacy), 11 (LTS), 16, 17 (LTS), 21 (LTS), or latest (recommended for new projects) | string | latest |
| installMaven | Install Apache Maven build automation and project management tool for Java projects | boolean | true |
| installGradle | Install Gradle modern build automation tool with Kotlin DSL support | boolean | false |
| jdkDistro | Java distribution: 'openjdk' (default system packages) or 'temurin' (Eclipse Adoptium - recommended for enterprise) | string | openjdk |

## Customizations

### VS Code Extensions

- `vscjava.vscode-java-pack`
- `redhat.java`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/alishah730/devcontainer-essentials/blob/main/src/java/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
