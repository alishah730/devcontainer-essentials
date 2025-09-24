
# nodejs from devcontainer-essentials (nodejs)

Install Node.js JavaScript runtime with npm, optional Yarn and pnpm package managers. Supports versions 10, 12, 14, 16, 18, 20, LTS, and latest. Perfect for web development, APIs, and full-stack applications.

## Example Usage

```json
"features": {
    "ghcr.io/alishah730/devcontainer-essentials/nodejs:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Node.js version: 10-20 (specific), 'lts' (Long Term Support - recommended), or 'latest' (cutting edge) | string | lts |
| installYarn | Install Yarn package manager - fast, reliable, and secure dependency management | boolean | true |
| installPnpm | Install pnpm package manager - performant npm alternative with efficient disk space usage | boolean | false |
| nodePackageManager | Set default package manager: 'npm' (built-in), 'yarn' (if installed), or 'pnpm' (if installed) | string | npm |

## Customizations

### VS Code Extensions

- `ms-vscode.vscode-typescript-next`
- `ms-vscode.vscode-eslint`
- `bradlc.vscode-tailwindcss`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/alishah730/devcontainer-essentials/blob/main/src/nodejs/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
