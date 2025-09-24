#!/bin/bash

# Test script for Node.js feature

set -e

# Source test library
source dev-container-features-test-lib

# Test Node.js installation  
check "node version" node --version
check "npm version" npm --version

# Test Yarn installation (if enabled)
if command -v yarn >/dev/null 2>&1; then
    check "yarn version" yarn --version
    check "yarn in path" which yarn
fi

# Test pnpm installation (if enabled)
if command -v pnpm >/dev/null 2>&1; then
    check "pnpm version" pnpm --version
    check "pnpm in path" which pnpm
fi

# Test environment variables
check "node in path" which node
check "npm in path" which npm

# Test basic functionality
check "node execute test" bash -c "echo 'console.log(\"Hello Node.js!\");' | node"
check "npm list test" npm list -g --depth=0

# Test npm configuration
check "npm config test" npm config get registry

# Test package installation
check "npm install test" bash -c "mkdir -p /tmp/npm-test && cd /tmp/npm-test && npm init -y && npm install lodash && node -e 'console.log(require(\"lodash\").VERSION)'"

# Clean up test
rm -rf /tmp/npm-test

# Report results
reportResults
