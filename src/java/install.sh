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
    JAVA_VERSION="$_BUILD_ARG_VERSION"
elif [ -n "$VERSION" ]; then
    JAVA_VERSION="$VERSION"
else
    JAVA_VERSION="latest"
fi

INSTALL_MAVEN=${_BUILD_ARG_INSTALLMAVEN:-${INSTALLMAVEN:-"true"}}
INSTALL_GRADLE=${_BUILD_ARG_INSTALLGRADLE:-${INSTALLGRADLE:-"false"}}
JDK_DISTRO=${_BUILD_ARG_JDKDISTRO:-${JDKDISTRO:-"openjdk"}}

echo "Starting installation of Java ${JAVA_VERSION} (${JDK_DISTRO})..."
echo "Debug: Final JAVA_VERSION = '$JAVA_VERSION'"

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

# Install Java
echo "Installing Java ${JAVA_VERSION}..."
install_java() {
    echo "Debug: Entering case statement with JAVA_VERSION='$JAVA_VERSION'"
    case $JAVA_VERSION in
        "8")
            if [ "$JDK_DISTRO" = "temurin" ]; then
                # Install Eclipse Temurin 8
                wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add -
                echo "deb https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/adoptium.list
                apt-get update
                apt-get install -y temurin-8-jdk
                export JAVA_HOME=/usr/lib/jvm/temurin-8-jdk-amd64
            else
                apt-get install -y openjdk-8-jdk
                export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
            fi
            ;;
        "11")
            if [ "$JDK_DISTRO" = "temurin" ]; then
                wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add -
                echo "deb https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/adoptium.list
                apt-get update
                apt-get install -y temurin-11-jdk
                export JAVA_HOME=/usr/lib/jvm/temurin-11-jdk-amd64
            else
                apt-get install -y openjdk-11-jdk
                export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
            fi
            ;;
        "16")
            echo "Debug: Installing Java 16 with distribution: $JDK_DISTRO"
            if [ "$JDK_DISTRO" = "temurin" ]; then
                echo "Debug: Installing Eclipse Temurin 16"
                wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add -
                echo "deb https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/adoptium.list
                apt-get update
                apt-get install -y temurin-16-jdk
                export JAVA_HOME=/usr/lib/jvm/temurin-16-jdk-amd64
            else
                echo "Debug: Installing OpenJDK 16"
                apt-get install -y openjdk-16-jdk
                export JAVA_HOME=/usr/lib/jvm/java-16-openjdk-amd64
            fi
            echo "Debug: Java 16 installation completed, JAVA_HOME=$JAVA_HOME"
            ;;
        "17")
            if [ "$JDK_DISTRO" = "temurin" ]; then
                wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add -
                echo "deb https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/adoptium.list
                apt-get update
                apt-get install -y temurin-17-jdk
                export JAVA_HOME=/usr/lib/jvm/temurin-17-jdk-amd64
            else
                apt-get install -y openjdk-17-jdk
                export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
            fi
            ;;
        "21")
            if [ "$JDK_DISTRO" = "temurin" ]; then
                wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add -
                echo "deb https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/adoptium.list
                apt-get update
                apt-get install -y temurin-21-jdk
                export JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
            else
                apt-get install -y openjdk-21-jdk
                export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
            fi
            ;;
        "latest")
            echo "Debug: Installing latest Java (default-jdk)"
            # Install the latest available OpenJDK
            apt-get install -y default-jdk
            export JAVA_HOME=/usr/lib/jvm/default-java
            echo "Debug: Latest Java installation completed, JAVA_HOME=$JAVA_HOME"
            ;;
        *)
            echo "Debug: Unsupported Java version: '${JAVA_VERSION}'"
            echo "Debug: Available versions are: 8, 11, 16, 17, 21, latest"
            echo "Unsupported Java version: ${JAVA_VERSION}"
            exit 1
            ;;
    esac
    
    # Detect actual JAVA_HOME if not set correctly
    if [ ! -d "$JAVA_HOME" ]; then
        echo "Warning: JAVA_HOME $JAVA_HOME does not exist, detecting actual path..."
        JAVA_HOME=$(java -XshowSettings:properties -version 2>&1 | grep 'java.home' | awk '{print $3}' | head -1)
        echo "Detected JAVA_HOME: $JAVA_HOME"
    fi
    
    # Set JAVA_HOME in profile
    echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/environment
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/environment
    
    # Also create a profile script for immediate availability
    cat > /etc/profile.d/java.sh << EOF
#!/bin/bash
export JAVA_HOME=${JAVA_HOME}
export PATH=\$JAVA_HOME/bin:\$PATH
EOF
    chmod +x /etc/profile.d/java.sh
    
    # Verify installation
    java_version=$(java -version 2>&1 | head -n 1)
    echo "Java installed: ${java_version}"
    echo "JAVA_HOME set to: ${JAVA_HOME}"
}

# Install Maven if requested
install_maven() {
    if [ "$INSTALL_MAVEN" = "true" ]; then
        echo "Installing Apache Maven..."
        apt-get install -y maven
        mvn_version=$(mvn --version | head -n 1)
        echo "Maven installed: ${mvn_version}"
    fi
}

# Install Gradle if requested
install_gradle() {
    if [ "$INSTALL_GRADLE" = "true" ]; then
        echo "Installing Gradle..."
        # Download and install latest Gradle
        GRADLE_VERSION="8.4"
        wget -O gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
        unzip -d /opt/gradle gradle.zip
        rm gradle.zip
        ln -s "/opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle" /usr/local/bin/gradle
        chmod +x /usr/local/bin/gradle
        
        # Set Gradle environment
        echo "export GRADLE_HOME=/opt/gradle/gradle-${GRADLE_VERSION}" >> /etc/environment
        echo "export PATH=\$GRADLE_HOME/bin:\$PATH" >> /etc/environment
        
        gradle_version=$(gradle --version | head -n 1)
        echo "Gradle installed: ${gradle_version}"
    fi
}

# Run installations
install_java
install_maven
install_gradle

# Clean up
echo "Cleaning up..."
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Java installation completed successfully!"
echo "Java version: $(java -version 2>&1 | head -n 1)"
echo "JAVA_HOME: ${JAVA_HOME}"

if [ "$INSTALL_MAVEN" = "true" ]; then
    echo "Maven version: $(mvn --version | head -n 1)"
fi

if [ "$INSTALL_GRADLE" = "true" ]; then
    echo "Gradle version: $(gradle --version | head -n 1)"
fi
