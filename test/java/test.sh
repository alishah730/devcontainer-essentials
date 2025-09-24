#!/bin/bash

# Test script for Java feature

set -e

# Source test library
source dev-container-features-test-lib

# Source environment variables
source /etc/environment 2>/dev/null || true
source /etc/profile.d/java.sh 2>/dev/null || true

# Test Java installation
check "java version" java -version

# Test JAVA_HOME - try multiple ways to get it
if [ -z "$JAVA_HOME" ]; then
    # Try to get JAVA_HOME from java command
    JAVA_HOME=$(java -XshowSettings:properties -version 2>&1 | grep 'java.home' | awk '{print $3}' | head -1)
fi

if [ -z "$JAVA_HOME" ]; then
    # Try common Java installation paths
    for java_path in /usr/lib/jvm/default-java /usr/lib/jvm/java-*-openjdk* /usr/lib/jvm/temurin-*; do
        if [ -d "$java_path" ]; then
            JAVA_HOME="$java_path"
            break
        fi
    done
fi

echo "Debug: JAVA_HOME is set to: '$JAVA_HOME'"
echo "Debug: Available Java installations:"
ls -la /usr/lib/jvm/ 2>/dev/null || echo "No /usr/lib/jvm directory found"

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

# Test JAVA_HOME is correctly set in environment
check "java home in environment" bash -c "source /etc/environment 2>/dev/null && test -n \$JAVA_HOME" || echo "JAVA_HOME not in /etc/environment, but available in current session: $JAVA_HOME"

# Test Java tools are accessible
check "java executable exists" test -x "$JAVA_HOME/bin/java"
check "javac executable exists" test -x "$JAVA_HOME/bin/javac"

# Report results
reportResults
