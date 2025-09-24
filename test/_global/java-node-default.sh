#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Definition specific tests
check "check for java" java --version
check "check for node" node --version


# Report result
reportResults