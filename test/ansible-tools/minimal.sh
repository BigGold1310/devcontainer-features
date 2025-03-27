#!/bin/bash

# This test file will be executed against the 'minimal' scenario in scenarios.json
# that includes 'ansible-tools' with only core ansible and other tools disabled

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Test that ansible is installed
check "ansible installed" command -v ansible

# Test that ansible-builder is NOT installed
check "ansible-builder not installed" bash -c "command -v ansible-builder && exit 1 || exit 0"

# Test that ansible-lint is NOT installed
check "ansible-lint not installed" bash -c "command -v ansible-lint && exit 1 || exit 0"

# Test that ansible-navigator is NOT installed
check "ansible-navigator not installed" bash -c "command -v ansible-navigator && exit 1 || exit 0"

# Test that no collections are installed
check "no collections installed" bash -c "ansible-galaxy collection list | grep -q 'No Collection found' || ansible-galaxy collection list | grep -q 'not found'"

# Report result
reportResults