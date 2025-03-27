#!/bin/bash
set -e

# Ansible Tools Installer for Dev Containers
# This script installs Ansible and related tools using pipx for isolation and version management.

# Parse option values
ANSIBLE_VERSION="${ansibleVersion:-latest}"
ANSIBLE_BUILDER_VERSION="${ansibleBuilderVersion:-latest}"
ANSIBLE_LINT_VERSION="${ansibleLintVersion:-latest}"
ANSIBLE_NAVIGATOR_VERSION="${ansibleNavigatorVersion:-none}"
ANSIBLE_COLLECTIONS="${ansibleCollections:-community.general}"

echo "📦 Installing Ansible tools..."
echo "   - Ansible: ${ANSIBLE_VERSION}"
echo "   - Ansible Builder: ${ANSIBLE_BUILDER_VERSION}"
echo "   - Ansible Lint: ${ANSIBLE_LINT_VERSION}"
echo "   - Ansible Navigator: ${ANSIBLE_NAVIGATOR_VERSION}"
echo "   - Ansible Collections: ${ANSIBLE_COLLECTIONS}"

# Make sure we're using noninteractive mode
export DEBIAN_FRONTEND=noninteractive

# -------------------------------------------------------
# Verify dependencies are available
# -------------------------------------------------------

# Verify Python is installed (should be provided by devcontainers/features/python)
if ! command -v python3 &> /dev/null; then
    echo "❌ Python is not installed. This feature requires the Python feature to be installed first."
    exit 1
fi

# Verify pipx is installed (should be provided by devcontainers/features/python)
if ! command -v pipx &> /dev/null; then
    echo "❌ pipx is not installed. This feature requires the Python feature to be installed first."
    exit 1
fi

# -------------------------------------------------------
# Installation functions
# -------------------------------------------------------

# Function to install package with pipx
install_package_with_pipx() {
    package_name=$1
    version=$2
    inject_deps=$3  # Optional space-separated list of packages to inject
    
    if [ "$version" = "none" ]; then
        echo "   Skipping installation of $package_name"
        return 0
    elif [ "$version" = "latest" ]; then
        echo "   Installing latest $package_name..."
        pipx install "$package_name"
    else
        echo "   Installing $package_name==$version..."
        pipx install "$package_name==$version"
    fi
    
    # Inject additional dependencies if specified
    if [ -n "$inject_deps" ]; then
        echo "   Injecting dependencies into $package_name: $inject_deps"
        pipx inject "$package_name" $inject_deps
    fi
}

# -------------------------------------------------------
# Main installation process
# -------------------------------------------------------

# Create a log file for installation outputs
LOG_FILE="/tmp/ansible-tools-install.log"
touch "$LOG_FILE"

# Perform all installations in a single block to minimize layers
(
    # Install Ansible
    install_package_with_pipx ansible "$ANSIBLE_VERSION"
    
    # Install ansible-builder if requested
    if [ "$ANSIBLE_BUILDER_VERSION" != "none" ]; then
        install_package_with_pipx ansible-builder "$ANSIBLE_BUILDER_VERSION"
    fi
    
    # Install ansible-lint if requested
    if [ "$ANSIBLE_LINT_VERSION" != "none" ]; then
        install_package_with_pipx ansible-lint "$ANSIBLE_LINT_VERSION"
    fi
    
    # Install ansible-navigator if requested
    if [ "$ANSIBLE_NAVIGATOR_VERSION" != "none" ]; then
        install_package_with_pipx ansible-navigator "$ANSIBLE_NAVIGATOR_VERSION"
    fi
) &> "$LOG_FILE" || {
    echo "❌ Installation failed. See log for details:"
    cat "$LOG_FILE"
    rm -f "$LOG_FILE"
    exit 1
}

# -------------------------------------------------------
# Verification and summary
# -------------------------------------------------------

echo "✅ Ansible tools installation completed!"
echo "Installed versions:"

if command -v ansible &> /dev/null; then
    ANSIBLE_VER=$(ansible --version | head -n 1)
    echo "   - Ansible: $ANSIBLE_VER"
else
    echo "   - Ansible: Not installed or not in PATH"
fi

if [ "$ANSIBLE_BUILDER_VERSION" != "none" ] && command -v ansible-builder &> /dev/null; then
    BUILDER_VER=$(ansible-builder --version)
    echo "   - Ansible Builder: $BUILDER_VER"
fi

if [ "$ANSIBLE_LINT_VERSION" != "none" ] && command -v ansible-lint &> /dev/null; then
    LINT_VER=$(ansible-lint --version | head -n 1)
    echo "   - Ansible Lint: $LINT_VER"
fi

if [ "$ANSIBLE_NAVIGATOR_VERSION" != "none" ] && command -v ansible-navigator &> /dev/null; then
    NAV_VER=$(ansible-navigator --version)
    echo "   - Ansible Navigator: $NAV_VER"
fi

# Clean up log file
rm -f "$LOG_FILE"

# Print helpful usage information
echo "🎯 Ansible tools are ready to use!"
echo "   - Run 'ansible --help' to see available commands"
echo "   - All tools are installed in isolated environments using pipx"
echo "   - To run Ansible Galaxy commands, use: ansible-galaxy [command]"