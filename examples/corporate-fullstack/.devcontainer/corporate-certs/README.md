# Corporate SSL Certificates

This directory contains SSL certificates for corporate network access.

## Directory Structure

Organize certificates by purpose:

```
corporate-certs/
├── root-ca/
│   ├── corporate-root-ca.crt
│   └── backup-root-ca.crt
├── intermediate/
│   ├── dept-intermediate-ca.pem
│   └── proxy-intermediate.pem
├── proxy/
│   ├── ssl-proxy.cer
│   └── web-filter.cer
└── bundles/
    └── complete-chain.p7b
```

## Certificate Sources

### Internal Certificate Authority
- Root CA certificates from your organization
- Intermediate CA certificates for different departments
- Internal service certificates

### SSL Inspection/Proxy
- Corporate firewall certificates
- Web filtering appliance certificates
- Network security device certificates

### Third-Party Services
- Partner organization certificates
- Vendor-specific CA certificates
- Cloud service certificates

## Installation Process

The SSL certificates feature will:

1. **Scan** this directory for certificate files
2. **Validate** each certificate format
3. **Install** certificates to system CA store
4. **Update** Java truststore (if Java feature is used)
5. **Configure** Node.js certificate settings (if Node.js feature is used)
6. **Set** environment variables for various tools

## Verification

After container creation, verify certificates are installed:

```bash
# Check system certificates
ls /usr/local/share/ca-certificates/custom/

# Test HTTPS connectivity
curl -v https://your-corporate-site.com

# Check Java truststore (if Java is installed)
keytool -list -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit | grep -i corporate

# Check Node.js configuration (if Node.js is installed)
echo $NODE_EXTRA_CA_CERTS
```

## Maintenance

- **Update certificates** before expiration
- **Remove obsolete** certificates regularly
- **Test connectivity** after certificate updates
- **Document certificate** sources and purposes
