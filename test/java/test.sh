#!/bin/bash

# Test script for Java feature

set -e

# Source test library
source dev-container-features-test-lib

# Test Java installation
check "java version" java -version
check "java home set" test -n "$JAVA_HOME"
check "java home exists" test -d "$JAVA_HOME"

# Test Maven installation (if enabled)
if command -v mvn >/dev/null 2>&1; then
    check "maven version" mvn --version
    check "maven in path" which mvn
fi

# Test Gradle installation (if enabled)
if command -v gradle >/dev/null 2>&1; then
    check "gradle version" gradle --version
    check "gradle in path" which gradle
fi

# Test environment variables
check "java in path" which java
check "javac in path" which javac

# Test basic functionality
check "java compile test" bash -c "echo 'public class Test { public static void main(String[] args) { System.out.println(\"Hello Java!\"); } }' > Test.java && javac Test.java && java Test"

# Test JAVA_HOME is correctly set
check "java home in environment" bash -c "source /etc/environment && test -n \$JAVA_HOME"

# Report results
reportResults
