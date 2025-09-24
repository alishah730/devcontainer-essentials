#!/bin/bash

# Common library functions for Node.js devcontainer feature

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

# Download and verify a file
download_file() {
    local url=$1
    local output=$2
    local expected_checksum=$3
    
    echo "Downloading $url..."
    curl -fsSL "$url" -o "$output"
    
    if [ -n "$expected_checksum" ]; then
        local actual_checksum=$(sha256sum "$output" | cut -d' ' -f1)
        if [ "$actual_checksum" != "$expected_checksum" ]; then
            echo "Checksum verification failed for $output"
            echo "Expected: $expected_checksum"
            echo "Actual: $actual_checksum"
            exit 1
        fi
        echo "Checksum verified for $output"
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

# Update PATH for all users
update_global_path() {
    local new_path=$1
    local profile_file="/etc/profile.d/nodejs-feature.sh"
    
    mkdir -p "$(dirname "$profile_file")"
    echo "export PATH=\"${new_path}:\$PATH\"" >> "$profile_file"
    chmod +x "$profile_file"
    echo "Updated global PATH with: $new_path"
}

# Log function with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Error handling function
handle_error() {
    local exit_code=$1
    local line_number=$2
    echo "Error occurred in script at line $line_number with exit code $exit_code"
    exit $exit_code
}

# Set up error handling
set -eE
trap 'handle_error $? $LINENO' ERR

# Initialize
check_root
get_os_info
