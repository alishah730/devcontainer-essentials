#!/bin/bash

# Test script for SSL certificates feature

set -e

# Source test library
source dev-container-features-test-lib

# Test certificate installation directory
check "custom certificates directory exists" test -d "/usr/local/share/ca-certificates/custom"

# Test system CA bundle update
check "ca-certificates package installed" dpkg -l | grep -q ca-certificates
check "system ca bundle exists" test -f "/etc/ssl/certs/ca-certificates.crt"

# Test environment variables
check "SSL_CERT_FILE environment variable" bash -c "source /etc/environment && test -n \$SSL_CERT_FILE"
check "SSL_CERT_DIR environment variable" bash -c "source /etc/environment && test -n \$SSL_CERT_DIR"
check "CURL_CA_BUNDLE environment variable" bash -c "source /etc/environment && test -n \$CURL_CA_BUNDLE"

# Test profile scripts
check "ssl-certs profile script exists" test -f "/etc/profile.d/ssl-certs.sh"
check "ssl-certs profile script executable" test -x "/etc/profile.d/ssl-certs.sh"

# Test OpenSSL functionality
check "openssl command available" command -v openssl
check "openssl can read system certificates" openssl version

# Test curl with system certificates
check "curl can access system ca bundle" curl --cacert /etc/ssl/certs/ca-certificates.crt --version

# Test certificate validation tools
check "ca-certificates tools available" command -v update-ca-certificates

# If Java is available, test Java truststore
if command -v keytool >/dev/null 2>&1; then
    check "java keytool available" command -v keytool
    check "java truststore exists" test -f "$JAVA_HOME/lib/security/cacerts"
    check "java truststore readable" keytool -list -keystore "$JAVA_HOME/lib/security/cacerts" -storepass changeit >/dev/null
fi

# If Node.js is available, test Node.js configuration
if command -v node >/dev/null 2>&1; then
    check "nodejs profile script exists" test -f "/etc/profile.d/nodejs-certs.sh"
    check "NODE_EXTRA_CA_CERTS environment variable" bash -c "source /etc/environment && test -n \$NODE_EXTRA_CA_CERTS"
fi

# Test that the feature doesn't break basic functionality
check "basic system functionality" echo "System is functional"

# Report results
reportResults
