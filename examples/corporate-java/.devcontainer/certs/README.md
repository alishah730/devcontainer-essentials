# Corporate Certificates Directory

This directory contains SSL certificates that will be automatically installed into the devcontainer.

## Supported File Types

- `*.crt` - X.509 certificate files
- `*.pem` - PEM-encoded certificates  
- `*.cer` - Certificate files (usually DER format)
- `*.p7b` - PKCS#7 certificate bundles

## Example Files

Place your corporate certificates here:

```
certs/
├── corporate-root-ca.crt       # Root CA certificate
├── intermediate-ca.pem         # Intermediate CA certificate
├── proxy-certificate.cer       # SSL proxy certificate
└── certificate-bundle.p7b      # Bundle of multiple certificates
```

## Getting Certificates

### From Windows Certificate Store
1. Open `certmgr.msc`
2. Navigate to "Trusted Root Certification Authorities" > "Certificates"
3. Right-click on your corporate certificate
4. Select "All Tasks" > "Export"
5. Choose "Base-64 encoded X.509 (.CER)" format
6. Save to this directory

### From Browser
1. Visit a corporate HTTPS site
2. Click the lock icon in the address bar
3. View certificate details
4. Export the certificate chain
5. Save each certificate to this directory

### From IT Department
Contact your IT department for:
- Corporate root CA certificates
- Intermediate CA certificates  
- SSL inspection/proxy certificates

## Security Notes

- **Do not commit private keys** to version control
- Only place **public certificates** in this directory
- Certificates will be installed system-wide in the container
- Original files remain unchanged

## Troubleshooting

If certificates are not being installed:

1. Check file permissions: `chmod 644 *.crt`
2. Verify certificate format: `openssl x509 -in certificate.crt -text -noout`
3. Enable verbose logging in devcontainer.json
4. Check container logs for error messages
