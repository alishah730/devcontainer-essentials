# Node.js DevContainer Feature

This devcontainer feature installs Node.js in your development container, providing a complete JavaScript/TypeScript development environment.

## Features

- **Node.js Support**: Install Node.js versions 10, 12, 14, 16, 18, 20, LTS, or latest
- **Package Managers**: Support for npm, Yarn, and pnpm
- **VS Code Integration**: Automatic installation of JavaScript/TypeScript extensions
- **Configurable Defaults**: Set your preferred package manager

## Usage

Add this feature to your `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/nodejs:1": {
      "version": "lts",
      "installYarn": true,
      "installPnpm": false,
      "nodePackageManager": "npm"
    }
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `"lts"` | Node.js version to install (`10`, `12`, `14`, `16`, `18`, `20`, `lts`, `latest`) |
| `installYarn` | boolean | `true` | Install Yarn package manager |
| `installPnpm` | boolean | `false` | Install pnpm package manager |
| `nodePackageManager` | string | `"npm"` | Default package manager (`npm`, `yarn`, `pnpm`) |

## Examples

### Basic Node.js Setup
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/nodejs:1": {}
  }
}
```

### React Development
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/nodejs:1": {
      "version": "18",
      "installYarn": true,
      "nodePackageManager": "yarn"
    }
  }
}
```

### Modern JavaScript Development
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/nodejs:1": {
      "version": "latest",
      "installYarn": true,
      "installPnpm": true,
      "nodePackageManager": "pnpm"
    }
  }
}
```

### Legacy Node.js Application
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/nodejs:1": {
      "version": "14",
      "installYarn": false,
      "installPnpm": false
    }
  }
}
```

## Environment Variables

The following environment variables are automatically set:

- `NODE_PATH`: Path to Node.js global modules
- `NPM_CONFIG_PACKAGE_MANAGER`: Default package manager (if specified)

## VS Code Extensions

The feature automatically installs the following VS Code extensions:

- **TypeScript**: Enhanced TypeScript support
- **ESLint**: JavaScript/TypeScript linting
- **Tailwind CSS**: CSS framework support

## Supported Versions

| Node.js Version | Status | Notes |
|-----------------|--------|-------|
| 10 | ✅ | Legacy support |
| 12 | ✅ | Legacy support |
| 14 | ✅ | Legacy support |
| 16 | ✅ | Supported |
| 18 | ✅ | Supported |
| 20 | ✅ | Current LTS |
| LTS | ✅ | Latest LTS version |
| Latest | ✅ | Latest stable version |

## Package Managers

### npm
- Comes bundled with Node.js
- Configured with security and performance optimizations
- Registry set to npmjs.org by default

### Yarn
- Installs latest stable version from official repository
- Faster package installation and better dependency resolution
- Compatible with npm registry

### pnpm
- Installs via npm global package
- Efficient disk space usage with content-addressable storage
- Fast, disk space efficient package manager

## Configuration

The feature automatically configures npm with the following settings:
- Registry: https://registry.npmjs.org/
- Audit level: moderate
- Fund notifications: disabled
- Update notifications: disabled (in CI environments)

## Troubleshooting

### Node.js Installation Issues
- Some older Node.js versions may not be available on newer Ubuntu versions
- Use `node --version` and `npm --version` to verify installation
- Check Node.js official documentation for version support

### Package Manager Issues
- Ensure the selected default package manager is installed
- Verify installations with `yarn --version` or `pnpm --version`
- Check package manager documentation for specific issues

### Permission Issues
- Global npm packages are installed to `/usr/local/lib/node_modules`
- Use `npm config get prefix` to check npm prefix location
- Consider using `npx` for running packages without global installation

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
