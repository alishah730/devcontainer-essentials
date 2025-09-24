# Java DevContainer Feature

This devcontainer feature installs Java (OpenJDK) in your development container, providing a complete Java development environment.

## Features

- **Java Support**: Install OpenJDK versions 8, 11, 17, 21, or latest
- **JDK Distributions**: Support for OpenJDK and Eclipse Temurin
- **Build Tools**: Optional Maven and Gradle installation
- **VS Code Integration**: Automatic installation of Java development extensions

## Usage

Add this feature to your `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/java:1": {
      "version": "17",
      "installMaven": true,
      "installGradle": false,
      "jdkDistro": "openjdk"
    }
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `"17"` | Java version to install (`8`, `11`, `17`, `21`, `latest`) |
| `installMaven` | boolean | `true` | Install Apache Maven for Java project management |
| `installGradle` | boolean | `false` | Install Gradle for Java project management |
| `jdkDistro` | string | `"openjdk"` | Java distribution (`openjdk`, `temurin`) |

## Examples

### Basic Java Setup
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/java:1": {}
  }
}
```

### Spring Boot Development
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/java:1": {
      "version": "17",
      "installMaven": true,
      "jdkDistro": "temurin"
    }
  }
}
```

### Legacy Java Application
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/java:1": {
      "version": "8",
      "installMaven": true,
      "installGradle": false
    }
  }
}
```

### Modern Java with Gradle
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/java:1": {
      "version": "21",
      "installMaven": false,
      "installGradle": true,
      "jdkDistro": "temurin"
    }
  }
}
```

## Environment Variables

The following environment variables are automatically set:

- `JAVA_HOME`: Path to the Java installation
- `PATH`: Updated to include Java binaries

## VS Code Extensions

The feature automatically installs the following VS Code extensions:

- **Java Extension Pack**: Complete Java development support
- **Red Hat Java**: Enhanced Java language support

## Supported Versions

| Java Version | OpenJDK | Eclipse Temurin | Status |
|--------------|---------|-----------------|--------|
| 8 | ✅ | ✅ | Supported |
| 11 | ✅ | ✅ | Supported |
| 17 | ✅ | ✅ | Supported |
| 21 | ✅ | ✅ | Supported |
| Latest | ✅ | ❌ | Supported |

## Build Tools

### Maven
- Automatically installs the latest stable version
- Configured with standard settings
- Available globally via `mvn` command

### Gradle
- Installs Gradle 8.4 (latest stable)
- Sets up `GRADLE_HOME` environment variable
- Available globally via `gradle` command

## Troubleshooting

### Java Installation Issues
- Ensure your base image supports the selected Java version
- Check if `JAVA_HOME` is properly set after installation
- Verify Java installation with `java -version`

### Build Tool Issues
- Maven requires Java to be installed first
- Gradle installation downloads from official sources
- Verify installations with `mvn --version` or `gradle --version`

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
