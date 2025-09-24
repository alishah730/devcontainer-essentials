#!/bin/bash
set -e

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Import the script library
source "${SCRIPT_DIR}/library_scripts.sh"

# Feature options - Use _BUILD_ARG_ prefixed variables from devcontainer feature system
echo "Debug: _BUILD_ARG_VERSION = '$_BUILD_ARG_VERSION'"
echo "Debug: VERSION = '$VERSION'"

# Try both _BUILD_ARG_VERSION and VERSION for compatibility
if [ -n "$_BUILD_ARG_VERSION" ]; then
    NODE_VERSION="$_BUILD_ARG_VERSION"
elif [ -n "$VERSION" ]; then
    NODE_VERSION="$VERSION"
else
    NODE_VERSION="lts"
fi

INSTALL_YARN=${_BUILD_ARG_INSTALLYARN:-${INSTALLYARN:-"true"}}
INSTALL_PNPM=${_BUILD_ARG_INSTALLPNPM:-${INSTALLPNPM:-"false"}}
NODE_PACKAGE_MANAGER=${_BUILD_ARG_NODEPACKAGEMANAGER:-${NODEPACKAGEMANAGER:-"npm"}}

echo "Debug: Final NODE_VERSION = '$NODE_VERSION'"

echo "Starting installation of Node.js ${NODE_VERSION}..."

# Update package lists
echo "Updating package lists..."
apt-get update

# Install common dependencies
echo "Installing common dependencies..."
apt-get install -y \
    curl \
    wget \
    gnupg \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    lsb-release

# Install Node.js
echo "Installing Node.js ${NODE_VERSION}..."
install_nodejs() {
    # Install Node.js using NodeSource repository
    case $NODE_VERSION in
        "10")
            curl -fsSL https://deb.nodesource.com/setup_10.x | bash -
            ;;
        "12")
            curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
            ;;
        "14")
            curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
            ;;
        "16")
            curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
            ;;
        "18")
            curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
            ;;
        "20")
            curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
            ;;
        "latest")
            curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
            ;;
        "lts")
            curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
            ;;
        *)
            echo "Unsupported Node.js version: ${NODE_VERSION}"
            exit 1
            ;;
    esac
    
    apt-get install -y nodejs
    
    # Verify installation
    node_version=$(node --version)
    npm_version=$(npm --version)
    echo "Node.js installed: ${node_version}"
    echo "npm installed: ${npm_version}"
    
    # Set npm global directory for non-root users
    mkdir -p /usr/local/lib/node_modules
    chown -R root:root /usr/local/lib/node_modules
    chmod -R 755 /usr/local/lib/node_modules
}

# Install Yarn if requested
install_yarn() {
    if [ "$INSTALL_YARN" = "true" ]; then
        echo "Installing Yarn..."
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
        apt-get update
        apt-get install -y yarn
        yarn_version=$(yarn --version)
        echo "Yarn installed: ${yarn_version}"
    fi
}

# Install pnpm if requested
install_pnpm() {
    if [ "$INSTALL_PNPM" = "true" ]; then
        echo "Installing pnpm..."
        npm install -g pnpm
        pnpm_version=$(pnpm --version)
        echo "pnpm installed: ${pnpm_version}"
    fi
}

# Set default package manager
set_default_package_manager() {
    case $NODE_PACKAGE_MANAGER in
        "yarn")
            if [ "$INSTALL_YARN" = "true" ]; then
                echo "Setting Yarn as default package manager..."
                echo "export NPM_CONFIG_PACKAGE_MANAGER=yarn" >> /etc/environment
            else
                echo "Warning: Yarn selected as default but not installed. Using npm."
            fi
            ;;
        "pnpm")
            if [ "$INSTALL_PNPM" = "true" ]; then
                echo "Setting pnpm as default package manager..."
                echo "export NPM_CONFIG_PACKAGE_MANAGER=pnpm" >> /etc/environment
            else
                echo "Warning: pnpm selected as default but not installed. Using npm."
            fi
            ;;
        "npm")
            echo "Using npm as default package manager..."
            ;;
        *)
            echo "Unknown package manager: ${NODE_PACKAGE_MANAGER}. Using npm."
            ;;
    esac
}

# Configure npm for better security and performance
configure_npm() {
    echo "Configuring npm..."
    
    # Set npm registry (optional, defaults to npmjs.org)
    npm config set registry https://registry.npmjs.org/
    
    # Set npm audit level
    npm config set audit-level moderate
    
    # Set npm fund to false to reduce noise
    npm config set fund false
    
    # Set npm update-notifier to false in CI environments
    npm config set update-notifier false
    
    echo "npm configuration completed"
}

# Run installations
install_nodejs
install_yarn
install_pnpm
set_default_package_manager
configure_npm

# Clean up
echo "Cleaning up..."
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Node.js installation completed successfully!"
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

if [ "$INSTALL_YARN" = "true" ]; then
    echo "Yarn version: $(yarn --version)"
fi

if [ "$INSTALL_PNPM" = "true" ]; then
    echo "pnpm version: $(pnpm --version)"
fi

echo "Default package manager: ${NODE_PACKAGE_MANAGER}"
