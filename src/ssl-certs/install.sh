#!/bin/bash
set -e

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Import the script library
source "${SCRIPT_DIR}/library_scripts.sh"

# Feature options - Use _BUILD_ARG_ prefixed variables from devcontainer feature system
echo "Debug: _BUILD_ARG_CERTSPATH = '$_BUILD_ARG_CERTSPATH'"
echo "Debug: CERTSPATH = '$CERTSPATH'"

# Try both _BUILD_ARG_ and non-prefixed variables for compatibility
CERTS_PATH=${_BUILD_ARG_CERTSPATH:-${CERTSPATH:-".devcontainer/certs"}}
UPDATE_CA_BUNDLE=${_BUILD_ARG_UPDATECABUNDLE:-${UPDATECABUNDLE:-"true"}}
TRUST_JAVA_CERTS=${_BUILD_ARG_TRUSTJAVACERTS:-${TRUSTJAVACERTS:-"true"}}
TRUST_NODE_CERTS=${_BUILD_ARG_TRUSTNODECERTS:-${TRUSTNODECERTS:-"true"}}
VERBOSE_LOGGING=${_BUILD_ARG_VERBOSELOGGING:-${VERBOSELOGGING:-"false"}}

echo "Debug: Final CERTS_PATH = '$CERTS_PATH'"

# Enable verbose logging if requested
if [ "$VERBOSE_LOGGING" = "true" ]; then
    set -x
fi

echo "🔒 Starting SSL Certificate installation..."

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check if certificates directory exists
check_certs_directory() {
    local workspace_root="${_REMOTE_USER_HOME:-/workspaces}"
    local full_certs_path
    
    # Try different possible workspace locations
    for possible_root in "/workspaces" "/workspace" "/app" "/src" "${_REMOTE_USER_HOME}" "${HOME}"; do
        if [ -d "${possible_root}" ]; then
            full_certs_path="${possible_root}/${CERTS_PATH}"
            if [ -d "$full_certs_path" ]; then
                echo "$full_certs_path"
                return 0
            fi
        fi
    done
    
    # Also check if CERTS_PATH is already absolute
    if [ -d "$CERTS_PATH" ]; then
        echo "$CERTS_PATH"
        return 0
    fi
    
    return 1
}

# Function to install certificates
install_certificates() {
    local certs_dir=$1
    local cert_count=0
    
    log_message "Installing certificates from: $certs_dir"
    
    # Create system certificate directory if it doesn't exist
    mkdir -p /usr/local/share/ca-certificates/custom
    
    # Process different certificate formats
    for cert_file in "$certs_dir"/*.{crt,pem,cer}; do
        # Skip if no files match the pattern
        [ -f "$cert_file" ] || continue
        
        local filename=$(basename "$cert_file")
        local extension="${filename##*.}"
        local basename="${filename%.*}"
        
        log_message "Processing certificate: $filename"
        
        case "$extension" in
            "crt"|"pem")
                # Copy directly
                cp "$cert_file" "/usr/local/share/ca-certificates/custom/${basename}.crt"
                cert_count=$((cert_count + 1))
                ;;
            "cer")
                # Convert .cer to .crt (they're usually the same format)
                cp "$cert_file" "/usr/local/share/ca-certificates/custom/${basename}.crt"
                cert_count=$((cert_count + 1))
                ;;
        esac
        
        if [ "$VERBOSE_LOGGING" = "true" ]; then
            log_message "Certificate details for $filename:"
            openssl x509 -in "$cert_file" -text -noout | head -20
        fi
    done
    
    # Process .p7b files (PKCS#7 bundles)
    for p7b_file in "$certs_dir"/*.p7b; do
        [ -f "$p7b_file" ] || continue
        
        local filename=$(basename "$p7b_file")
        local basename="${filename%.*}"
        
        log_message "Processing PKCS#7 bundle: $filename"
        
        # Extract certificates from PKCS#7 bundle
        openssl pkcs7 -inform DER -in "$p7b_file" -print_certs -out "/tmp/${basename}_bundle.pem" 2>/dev/null || \
        openssl pkcs7 -inform PEM -in "$p7b_file" -print_certs -out "/tmp/${basename}_bundle.pem"
        
        # Split the bundle into individual certificates
        awk 'BEGIN {c=0} /-----BEGIN CERTIFICATE-----/ {c++} {print > "/tmp/cert_" c ".pem"}' "/tmp/${basename}_bundle.pem"
        
        # Copy individual certificates
        for split_cert in /tmp/cert_*.pem; do
            [ -f "$split_cert" ] || continue
            if [ -s "$split_cert" ]; then  # Only if file is not empty
                local cert_num=$(basename "$split_cert" .pem | sed 's/cert_//')
                cp "$split_cert" "/usr/local/share/ca-certificates/custom/${basename}_${cert_num}.crt"
                cert_count=$((cert_count + 1))
            fi
            rm -f "$split_cert"
        done
        
        rm -f "/tmp/${basename}_bundle.pem"
    done
    
    echo "$cert_count"
}

# Function to update CA bundle
update_ca_certificates() {
    if [ "$UPDATE_CA_BUNDLE" = "true" ]; then
        log_message "Updating system CA certificate bundle..."
        update-ca-certificates
        
        # Also update for different distros
        if command -v update-ca-trust >/dev/null 2>&1; then
            update-ca-trust
        fi
    fi
}

# Function to configure Java truststore
configure_java_truststore() {
    if [ "$TRUST_JAVA_CERTS" = "true" ] && command -v keytool >/dev/null 2>&1; then
        log_message "Configuring Java truststore..."
        
        local java_home
        java_home=$(java -XshowSettings:properties -version 2>&1 | grep 'java.home' | awk '{print $3}')
        
        if [ -n "$java_home" ] && [ -f "$java_home/lib/security/cacerts" ]; then
            local truststore="$java_home/lib/security/cacerts"
            local storepass="changeit"  # Default Java truststore password
            
            for cert_file in /usr/local/share/ca-certificates/custom/*.crt; do
                [ -f "$cert_file" ] || continue
                
                local alias=$(basename "$cert_file" .crt)
                log_message "Adding certificate to Java truststore: $alias"
                
                # Remove existing alias if it exists (ignore errors)
                keytool -delete -alias "$alias" -keystore "$truststore" -storepass "$storepass" >/dev/null 2>&1 || true
                
                # Add the certificate
                keytool -importcert -noprompt -trustcacerts -alias "$alias" \
                    -file "$cert_file" -keystore "$truststore" -storepass "$storepass"
            done
        fi
    fi
}

# Function to configure Node.js certificates
configure_nodejs_certs() {
    if [ "$TRUST_NODE_CERTS" = "true" ]; then
        log_message "Configuring Node.js certificate settings..."
        
        # Set NODE_EXTRA_CA_CERTS to include system certificates
        local ca_bundle="/etc/ssl/certs/ca-certificates.crt"
        if [ -f "$ca_bundle" ]; then
            echo "export NODE_EXTRA_CA_CERTS=$ca_bundle" >> /etc/environment
            
            # Also create a profile script
            cat > /etc/profile.d/nodejs-certs.sh << EOF
#!/bin/bash
export NODE_EXTRA_CA_CERTS=$ca_bundle
EOF
            chmod +x /etc/profile.d/nodejs-certs.sh
        fi
        
        # Disable Node.js certificate verification if needed (not recommended for production)
        # echo "export NODE_TLS_REJECT_UNAUTHORIZED=0" >> /etc/environment
    fi
}

# Function to set up environment variables for other tools
setup_cert_environment() {
    log_message "Setting up certificate environment variables..."
    
    # Common certificate bundle locations
    local ca_bundle="/etc/ssl/certs/ca-certificates.crt"
    
    if [ -f "$ca_bundle" ]; then
        # Set environment variables for various tools
        cat >> /etc/environment << EOF

# SSL Certificate Configuration
SSL_CERT_FILE=$ca_bundle
SSL_CERT_DIR=/etc/ssl/certs
CURL_CA_BUNDLE=$ca_bundle
REQUESTS_CA_BUNDLE=$ca_bundle
EOF
        
        # Create a profile script for runtime
        cat > /etc/profile.d/ssl-certs.sh << EOF
#!/bin/bash
export SSL_CERT_FILE=$ca_bundle
export SSL_CERT_DIR=/etc/ssl/certs
export CURL_CA_BUNDLE=$ca_bundle
export REQUESTS_CA_BUNDLE=$ca_bundle
EOF
        chmod +x /etc/profile.d/ssl-certs.sh
    fi
}

# Main execution
main() {
    # Update package lists
    log_message "Updating package lists..."
    apt-get update
    
    # Install required tools
    log_message "Installing required tools..."
    apt-get install -y ca-certificates openssl curl
    
    # Check if certificates directory exists
    local certs_directory
    if certs_directory=$(check_certs_directory); then
        log_message "Found certificates directory: $certs_directory"
        
        # Count certificate files
        local total_files=0
        for ext in crt pem cer p7b; do
            total_files=$((total_files + $(find "$certs_directory" -name "*.$ext" 2>/dev/null | wc -l)))
        done
        
        if [ "$total_files" -eq 0 ]; then
            log_message "No certificate files found in $certs_directory. Skipping certificate installation."
            return 0
        fi
        
        log_message "Found $total_files certificate files to process"
        
        # Install certificates
        local installed_count
        installed_count=$(install_certificates "$certs_directory")
        
        if [ "$installed_count" -gt 0 ]; then
            log_message "Successfully installed $installed_count certificates"
            
            # Update CA bundle
            update_ca_certificates
            
            # Configure Java truststore (if Java is available)
            configure_java_truststore
            
            # Configure Node.js certificates
            configure_nodejs_certs
            
            # Set up environment variables
            setup_cert_environment
            
            log_message "✅ SSL certificate installation completed successfully!"
        else
            log_message "⚠️  No certificates were installed"
        fi
    else
        log_message "No certificates directory found at expected locations. Skipping certificate installation."
        log_message "Expected path: $CERTS_PATH (relative to workspace root)"
        log_message "To use this feature, create the directory and place your .crt, .pem, .cer, or .p7b files there."
    fi
}

# Run main function
main

# Clean up
log_message "Cleaning up..."
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

log_message "🔒 SSL Certificate feature installation completed!"
