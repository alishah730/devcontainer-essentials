#!/bin/bash

# Local testing script for devcontainer features
# This script helps test features locally before publishing

set -e

echo "🧪 Testing DevContainer Features Locally"
echo "========================================"

# Check if devcontainer CLI is installed
if ! command -v devcontainer >/dev/null 2>&1; then
    echo "❌ DevContainer CLI not found. Installing..."
    npm install -g @devcontainers/cli
fi

echo "✅ DevContainer CLI found"

# Test feature structure
echo "📁 Checking feature structure..."

for FEATURE in "java" "nodejs"; do
    FEATURE_DIR="src/$FEATURE"
    if [ ! -d "$FEATURE_DIR" ]; then
        echo "❌ Feature directory not found: $FEATURE_DIR"
        exit 1
    fi

    if [ ! -f "$FEATURE_DIR/devcontainer-feature.json" ]; then
        echo "❌ Feature metadata not found: $FEATURE_DIR/devcontainer-feature.json"
        exit 1
    fi

    if [ ! -f "$FEATURE_DIR/install.sh" ]; then
        echo "❌ Install script not found: $FEATURE_DIR/install.sh"
        exit 1
    fi

    if [ ! -x "$FEATURE_DIR/install.sh" ]; then
        echo "❌ Install script not executable: $FEATURE_DIR/install.sh"
        exit 1
    fi
    
    echo "✅ Feature $FEATURE structure valid"
done

echo "✅ Feature structure valid"

# Validate JSON files
echo "🔍 Validating JSON files..."

for json_file in $(find . -name "*.json" -not -path "./node_modules/*"); do
    if ! python3 -m json.tool "$json_file" >/dev/null 2>&1; then
        echo "❌ Invalid JSON: $json_file"
        exit 1
    fi
done

echo "✅ All JSON files valid"

# Test feature with devcontainer CLI
echo "🚀 Testing features with DevContainer CLI..."

# Test Java feature
echo "🧪 Testing Java feature..."
TEST_DIR_JAVA=$(mktemp -d)
cp -r test-configs/java-test.json "$TEST_DIR_JAVA/devcontainer.json"

# Update the feature path to use local source
sed -i.bak 's|"./src/java"|"'$(pwd)'/src/java"|g' "$TEST_DIR_JAVA/devcontainer.json"

echo "📝 Java test configuration:"
cat "$TEST_DIR_JAVA/devcontainer.json"

echo ""
echo "🏗️  Building Java test container..."
if devcontainer build --workspace-folder "$TEST_DIR_JAVA" --config "$TEST_DIR_JAVA/devcontainer.json"; then
    echo "✅ Java container built successfully!"
    
    if devcontainer exec --workspace-folder "$TEST_DIR_JAVA" --config "$TEST_DIR_JAVA/devcontainer.json" java -version; then
        echo "✅ Java installation verified"
    else
        echo "❌ Java installation failed"
    fi
else
    echo "❌ Java container build failed"
    exit 1
fi

# Test Node.js feature
echo ""
echo "🧪 Testing Node.js feature..."
TEST_DIR_NODE=$(mktemp -d)
cp -r test-configs/nodejs-test.json "$TEST_DIR_NODE/devcontainer.json"

# Update the feature path to use local source
sed -i.bak 's|"./src/nodejs"|"'$(pwd)'/src/nodejs"|g' "$TEST_DIR_NODE/devcontainer.json"

echo "📝 Node.js test configuration:"
cat "$TEST_DIR_NODE/devcontainer.json"

echo ""
echo "🏗️  Building Node.js test container..."
if devcontainer build --workspace-folder "$TEST_DIR_NODE" --config "$TEST_DIR_NODE/devcontainer.json"; then
    echo "✅ Node.js container built successfully!"
    
    if devcontainer exec --workspace-folder "$TEST_DIR_NODE" --config "$TEST_DIR_NODE/devcontainer.json" node --version; then
        echo "✅ Node.js installation verified"
    else
        echo "❌ Node.js installation failed"
    fi
    
    if devcontainer exec --workspace-folder "$TEST_DIR_NODE" --config "$TEST_DIR_NODE/devcontainer.json" npm --version; then
        echo "✅ npm installation verified"
    else
        echo "❌ npm installation failed"
    fi
else
    echo "❌ Node.js container build failed"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR_JAVA" "$TEST_DIR_NODE"

echo ""
echo "🎉 All tests passed!"
echo "Your devcontainer feature is ready for publication."
echo ""
echo "Next steps:"
echo "1. Push your code to GitHub"
echo "2. The GitHub Actions workflow will automatically publish your feature"
echo "3. Your features will be available at:"
echo "   - ghcr.io/alishah730/devcontainer-essentials/java:1"
echo "   - ghcr.io/alishah730/devcontainer-essentials/nodejs:1"
