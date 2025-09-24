# Publishing DevContainer Features to the Marketplace

This guide explains how to publish your devcontainer features to the GitHub Container Registry (GHCR) and make them available in the VS Code DevContainer marketplace.

## Prerequisites

1. **GitHub Repository**: Your features must be in a public GitHub repository
2. **GitHub Actions**: Enabled for your repository
3. **Container Registry**: Access to GitHub Container Registry (GHCR)

## Repository Structure

Your repository should follow this structure:

```
├── src/
│   └── java-node/                    # Feature name
│       ├── devcontainer-feature.json # Feature metadata
│       ├── install.sh                # Installation script
│       ├── library_scripts.sh        # Helper scripts
│       └── README.md                 # Feature documentation
├── test/
│   ├── _global/
│   │   └── scenarios.json            # Test scenarios
│   └── java-node/
│       └── test.sh                   # Feature tests
├── .github/
│   └── workflows/
│       ├── release.yml               # Publishing workflow
│       └── test.yml                  # Testing workflow
└── README.md                         # Repository documentation
```

## Publishing Steps

### 1. Prepare Your Repository

Ensure your repository has:
- ✅ Proper feature structure under `src/`
- ✅ Valid `devcontainer-feature.json` files
- ✅ Executable installation scripts
- ✅ Comprehensive tests
- ✅ GitHub Actions workflows

### 2. Configure GitHub Actions

The `.github/workflows/release.yml` workflow automatically:
- Publishes features to GHCR
- Generates documentation
- Creates releases

### 3. Enable GitHub Container Registry

1. Go to your repository settings
2. Navigate to "Actions" → "General"
3. Under "Workflow permissions", select "Read and write permissions"
4. Check "Allow GitHub Actions to create and approve pull requests"

### 4. Publish Features

Features are automatically published when you:
- Push to the `main` branch with changes in `src/`
- Manually trigger the "Release" workflow
- Create a new release tag

### 5. Verify Publication

After successful publication, your features will be available at:
```
ghcr.io/alishah730/REPOSITORY-NAME/FEATURE-NAME:VERSION
```

Example:
```
ghcr.io/alishah730/all-devcontainer/java-node:1
```

## Using Published Features

Once published, users can reference your features in their `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/java-node:1": {
      "javaVersion": "17",
      "nodeVersion": "lts"
    }
  }
}
```

## Marketplace Visibility

Published features automatically appear in:
1. **VS Code DevContainer Extension**: Feature picker UI
2. **GitHub Container Registry**: Public package listing
3. **DevContainer Feature Registry**: Community discovery

## Versioning

Features support semantic versioning:
- `1` - Latest major version 1
- `1.2` - Latest minor version 1.2
- `1.2.3` - Specific patch version

Update the `version` field in `devcontainer-feature.json` for new releases.

## Best Practices

### Feature Design
- ✅ Support multiple versions of tools
- ✅ Provide sensible defaults
- ✅ Include comprehensive options
- ✅ Handle errors gracefully

### Documentation
- ✅ Clear README with examples
- ✅ Document all options
- ✅ Include troubleshooting guide
- ✅ Provide usage scenarios

### Testing
- ✅ Test on multiple base images
- ✅ Test all option combinations
- ✅ Verify installations work correctly
- ✅ Include automated tests

### Security
- ✅ Validate user inputs
- ✅ Use official package sources
- ✅ Verify checksums when possible
- ✅ Follow least privilege principle

## Troubleshooting

### Publication Fails
- Check GitHub Actions logs
- Verify workflow permissions
- Ensure proper JSON syntax
- Check script execution permissions

### Feature Not Found
- Wait for registry propagation (up to 10 minutes)
- Verify correct registry URL
- Check feature name and version
- Ensure repository is public

### Installation Errors
- Test locally first
- Check base image compatibility
- Verify script dependencies
- Review error logs carefully

## Support

- 📖 [DevContainer Features Specification](https://containers.dev/implementors/features/)
- 🛠️ [DevContainer CLI](https://github.com/devcontainers/cli)
- 💬 [Community Discussions](https://github.com/devcontainers/features/discussions)

## Example Workflow

1. **Develop**: Create feature in `src/feature-name/`
2. **Test**: Run `devcontainer features test`
3. **Document**: Update README and examples
4. **Commit**: Push changes to trigger publication
5. **Verify**: Check GHCR for published package
6. **Share**: Update documentation with usage examples
