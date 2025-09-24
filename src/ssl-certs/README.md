
# ssl-certs from devcontainer-essentials (ssl-certs)

Automatically install custom CA SSL certificates for corporate environments with proxy servers, firewalls, and SSL inspection. Supports .crt, .pem, .cer, and .p7b certificate formats with Java truststore and Node.js integration.

## Example Usage

```json
"features": {
    "ghcr.io/alishah730/devcontainer-essentials/ssl-certs:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| certsPath | Path to the certificates folder relative to workspace root (supports .crt, .pem, .cer, .p7b files) | string | .devcontainer/certs |
| updateCaBundle | Update the system CA bundle after installing certificates | boolean | true |
| trustJavaCerts | Add certificates to Java truststore (if Java is available) | boolean | true |
| trustNodeCerts | Configure Node.js to use system certificates | boolean | true |
| verboseLogging | Enable detailed logging during certificate installation for troubleshooting corporate network issues | boolean | false |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/alishah730/devcontainer-essentials/blob/main/src/ssl-certs/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
