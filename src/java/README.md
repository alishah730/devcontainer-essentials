
# Java (OpenJDK) (java)

Install Java (OpenJDK) with support for versions 8 through latest

## Example Usage

```json
"features": {
    "ghcr.io/alishah730/devcontainer-essentials/java:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select the Java version to install | string | latest |
| installMaven | Install Apache Maven for Java project management | boolean | true |
| installGradle | Install Gradle for Java project management | boolean | false |
| jdkDistro | Java distribution to install | string | openjdk |

## Customizations

### VS Code Extensions

- `vscjava.vscode-java-pack`
- `redhat.java`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/alishah730/devcontainer-essentials/blob/main/src/java/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
