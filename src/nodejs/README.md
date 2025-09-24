
# Node.js (nodejs)

Install Node.js with support for versions 10 through latest

## Example Usage

```json
"features": {
    "ghcr.io/alishah730/devcontainer-essentials/nodejs:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select the Node.js version to install | string | lts |
| installYarn | Install Yarn package manager | boolean | true |
| installPnpm | Install pnpm package manager | boolean | false |
| nodePackageManager | Default package manager to use | string | npm |

## Customizations

### VS Code Extensions

- `ms-vscode.vscode-typescript-next`
- `ms-vscode.vscode-eslint`
- `bradlc.vscode-tailwindcss`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/alishah730/devcontainer-essentials/blob/main/src/nodejs/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
