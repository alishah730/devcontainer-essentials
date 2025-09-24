#!/bin/bash

# Common library functions for SSL certificates devcontainer feature

# Check if running as root
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run as root"
        exit 1
    fi
}

# Get the OS information
get_os_info() {
    . /etc/os-release
    echo "Operating System: $PRETTY_NAME"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate certificate file
validate_certificate() {
    local cert_file=$1
    
    if [ ! -f "$cert_file" ]; then
        echo "Certificate file not found: $cert_file"
        return 1
    fi
    
    # Try to parse the certificate
    if openssl x509 -in "$cert_file" -text -noout >/dev/null 2>&1; then
        return 0
    else
        echo "Invalid certificate format: $cert_file"
        return 1
    fi
}

# Get certificate information
get_cert_info() {
    local cert_file=$1
    
    if validate_certificate "$cert_file"; then
        echo "Certificate: $cert_file"
        echo "Subject: $(openssl x509 -in "$cert_file" -subject -noout | sed 's/subject=//')"
        echo "Issuer: $(openssl x509 -in "$cert_file" -issuer -noout | sed 's/issuer=//')"
        echo "Valid from: $(openssl x509 -in "$cert_file" -startdate -noout | sed 's/notBefore=//')"
        echo "Valid to: $(openssl x509 -in "$cert_file" -enddate -noout | sed 's/notAfter=//')"
        echo "---"
    fi
}

# Check if certificate is already installed
is_cert_installed() {
    local cert_file=$1
    local fingerprint
    
    fingerprint=$(openssl x509 -in "$cert_file" -fingerprint -noout | cut -d= -f2)
    
    # Check if fingerprint exists in system certificates
    for system_cert in /etc/ssl/certs/*.pem; do
        [ -f "$system_cert" ] || continue
        local system_fingerprint
        system_fingerprint=$(openssl x509 -in "$system_cert" -fingerprint -noout 2>/dev/null | cut -d= -f2)
        if [ "$fingerprint" = "$system_fingerprint" ]; then
            return 0
        fi
    done
    
    return 1
}

# Backup existing certificates
backup_certificates() {
    local backup_dir="/tmp/cert-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    
    if [ -d "/usr/local/share/ca-certificates/custom" ]; then
        cp -r /usr/local/share/ca-certificates/custom "$backup_dir/"
        echo "Certificates backed up to: $backup_dir"
    fi
}

# Set environment variable for all users
set_global_env() {
    local var_name=$1
    local var_value=$2
    local env_file="/etc/environment"
    
    if ! grep -q "^${var_name}=" "$env_file" 2>/dev/null; then
        echo "${var_name}=${var_value}" >> "$env_file"
        echo "Set global environment variable: ${var_name}=${var_value}"
    else
        echo "Environment variable ${var_name} already exists"
    fi
}

# Log function with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Error handling function
handle_error() {
    local exit_code=$1
    local line_number=$2
    echo "Error occurred in SSL certificate installation at line $line_number with exit code $exit_code"
    exit $exit_code
}

# Set up error handling
set -eE
trap 'handle_error $? $LINENO' ERR

# Initialize
check_root
get_os_info
