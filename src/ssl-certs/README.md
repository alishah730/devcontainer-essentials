# SSL Certificates DevContainer Feature

This devcontainer feature automatically installs custom CA SSL certificates for corporate environments. It's designed to run before other features to ensure all subsequent installations can access corporate resources through SSL proxies and firewalls.

## Features

- **Automatic Detection**: Scans for certificates in a configurable directory
- **Multiple Formats**: Supports `.crt`, `.pem`, `.cer`, and `.p7b` certificate formats
- **System Integration**: Updates system CA bundle and configures various tools
- **Java Support**: Automatically adds certificates to Java truststore
- **Node.js Support**: Configures Node.js to use system certificates
- **Corporate Friendly**: Designed for enterprise environments with SSL inspection

## Usage

### Basic Setup

1. Create a `certs` folder in your `.devcontainer` directory:
```
.devcontainer/
├── certs/
│   ├── corporate-ca.crt
│   ├── proxy-cert.pem
│   └── internal-ca.cer
└── devcontainer.json
```

2. Add the feature to your `devcontainer.json`:
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/ssl-certs:1": {}
  }
}
```

### Advanced Configuration

```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/ssl-certs:1": {
      "certsPath": ".devcontainer/certificates",
      "updateCaBundle": true,
      "trustJavaCerts": true,
      "trustNodeCerts": true,
      "verboseLogging": false
    }
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `certsPath` | string | `".devcontainer/certs"` | Path to certificates folder (relative to workspace root) |
| `updateCaBundle` | boolean | `true` | Update the system CA certificate bundle |
| `trustJavaCerts` | boolean | `true` | Add certificates to Java truststore (if Java is available) |
| `trustNodeCerts` | boolean | `true` | Configure Node.js to use system certificates |
| `verboseLogging` | boolean | `false` | Enable detailed logging during installation |

## Supported Certificate Formats

### Individual Certificates
- **`.crt`** - X.509 certificate in PEM or DER format
- **`.pem`** - PEM-encoded certificate
- **`.cer`** - Certificate file (usually DER format)

### Certificate Bundles
- **`.p7b`** - PKCS#7 certificate bundle (supports multiple certificates)

## Examples

### Corporate Environment
```json
{
  "name": "Corporate Development Environment",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/alishah730/all-devcontainer/ssl-certs:1": {
      "certsPath": ".devcontainer/corporate-certs",
      "verboseLogging": true
    },
    "ghcr.io/alishah730/all-devcontainer/java:1": {
      "version": "17"
    },
    "ghcr.io/alishah730/all-devcontainer/nodejs:1": {
      "version": "lts"
    }
  }
}
```

### Custom Certificate Location
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/ssl-certs:1": {
      "certsPath": "security/certificates"
    }
  }
}
```

### Java-Only Environment
```json
{
  "features": {
    "ghcr.io/alishah730/all-devcontainer/ssl-certs:1": {
      "trustNodeCerts": false,
      "trustJavaCerts": true
    }
  }
}
```

## Directory Structure Examples

### Basic Structure
```
.devcontainer/
├── certs/
│   ├── company-root-ca.crt
│   └── proxy-certificate.pem
└── devcontainer.json
```

### Advanced Structure
```
.devcontainer/
├── certificates/
│   ├── root-ca/
│   │   ├── corporate-root.crt
│   │   └── internal-ca.crt
│   ├── intermediate/
│   │   └── intermediate-ca.pem
│   └── bundles/
│       └── certificate-bundle.p7b
└── devcontainer.json
```

## Environment Variables Set

The feature automatically sets these environment variables:

- `SSL_CERT_FILE`: Path to the system CA bundle
- `SSL_CERT_DIR`: Directory containing system certificates
- `CURL_CA_BUNDLE`: CA bundle for curl
- `REQUESTS_CA_BUNDLE`: CA bundle for Python requests
- `NODE_EXTRA_CA_CERTS`: Additional CA certificates for Node.js

## Integration with Other Tools

### Java Applications
- Certificates are automatically added to the Java truststore
- Works with Maven, Gradle, and other Java tools
- Uses default truststore password (`changeit`)

### Node.js Applications
- Configures `NODE_EXTRA_CA_CERTS` to include system certificates
- Works with npm, yarn, and other Node.js tools
- Ensures HTTPS requests work through corporate proxies

### System Tools
- Updates system CA bundle for curl, wget, and other tools
- Configures environment variables for Python, Ruby, and other languages
- Works with Docker, Git, and other development tools

## Troubleshooting

### Certificates Not Found
```
No certificates directory found at expected locations. Skipping certificate installation.
```

**Solution**: Ensure your certificates directory exists and contains certificate files:
```bash
mkdir -p .devcontainer/certs
# Add your certificate files to this directory
```

### Invalid Certificate Format
```
Invalid certificate format: /path/to/cert.crt
```

**Solution**: Verify your certificate is in the correct format:
```bash
openssl x509 -in certificate.crt -text -noout
```

### Java Truststore Issues
```
keytool error: java.io.IOException: Keystore was tampered with, or password was incorrect
```

**Solution**: The Java truststore might be corrupted. This feature uses the default password `changeit`.

### Permission Issues
```
Permission denied when accessing certificate files
```

**Solution**: Ensure certificate files have appropriate permissions:
```bash
chmod 644 .devcontainer/certs/*.crt
```

## Security Considerations

### Certificate Validation
- The feature validates certificates before installation
- Invalid or corrupted certificates are skipped
- Detailed logging available with `verboseLogging: true`

### File Permissions
- Certificates are copied to system directories with appropriate permissions
- Original certificate files remain unchanged
- Backup of existing certificates is created

### Corporate Policies
- Only installs certificates from the specified directory
- Does not modify existing system certificates
- Respects corporate security policies

## Best Practices

### Certificate Management
1. **Organize certificates** in subdirectories by type or purpose
2. **Use descriptive names** for certificate files
3. **Keep certificates up to date** and monitor expiration dates
4. **Document certificate sources** and purposes

### Development Workflow
1. **Add ssl-certs feature first** in your feature list
2. **Test certificate installation** with verbose logging enabled
3. **Verify connectivity** to corporate resources after installation
4. **Share certificate directory** structure with team members

### Security
1. **Do not commit private keys** to version control
2. **Use appropriate file permissions** for certificate files
3. **Regularly update certificates** before expiration
4. **Monitor certificate usage** in logs

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
