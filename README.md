# All DevContainer Features

A collection of useful devcontainer features for development environments.

## Features

### Java (`java`)

Install Java (OpenJDK) in your devcontainer with support for multiple versions and build tools.

**Quick Start:**
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/java:1": {
      "version": "17",
      "installMaven": true
    }
  }
}
```

[📖 Full Documentation](./src/java/README.md)

### Node.js (`nodejs`)

Install Node.js in your devcontainer with support for multiple versions and package managers.

**Quick Start:**
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/nodejs:1": {
      "version": "lts",
      "installYarn": true
    }
  }
}
```

[📖 Full Documentation](./src/nodejs/README.md)

### SSL Certificates (`ssl-certs`)

Install custom CA SSL certificates for corporate environments. Runs before other features to ensure SSL connectivity.

**Quick Start:**
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/ssl-certs:1": {
      "certsPath": ".devcontainer/certs"
    }
  }
}
```

[📖 Full Documentation](./src/ssl-certs/README.md)

## Usage

Add any of these features to your `devcontainer.json` file:

```json
{
  "name": "My Development Environment",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/alishah730/all-devcontainer/ssl-certs:1": {
      "certsPath": ".devcontainer/certs"
    },
    "ghcr.io/alishah730/all-devcontainer/java:1": {
      "version": "17",
      "installMaven": true
    },
    "ghcr.io/alishah730/all-devcontainer/nodejs:1": {
      "version": "lts",
      "installYarn": true
    }
  }
}
```

## Available Features

| Feature | Description | Status |
|---------|-------------|--------|
| `ssl-certs` | SSL certificates for corporate environments | ✅ Ready |
| `java` | Java (8-latest) + Maven/Gradle | ✅ Ready |
| `nodejs` | Node.js (10-latest) + npm/Yarn/pnpm | ✅ Ready |

## Development

### Testing Features Locally

1. Clone this repository
2. Open in VS Code with the Dev Containers extension
3. Use the "Dev Containers: Rebuild Container" command to test changes

### Adding New Features

1. Create a new directory under `src/`
2. Add `devcontainer-feature.json` with feature metadata
3. Add `install.sh` with installation logic
4. Add `README.md` with documentation
5. Test the feature thoroughly

### Publishing to GitHub Container Registry

Features are automatically published to GHCR when you push to the main branch or create a release.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) for details.

## Support

- 📖 [Documentation](https://github.com/alishah730/all-devcontainer)
- 🐛 [Issues](https://github.com/alishah730/all-devcontainer/issues)
- 💬 [Discussions](https://github.com/alishah730/all-devcontainer/discussions)
