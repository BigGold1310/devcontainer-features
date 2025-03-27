#!/bin/bash

# This test file will be executed against the 'all_tools' scenario in scenarios.json
# that includes 'ansible-tools' with all components enabled

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Test that ansible is installed
check "ansible installed" command -v ansible

# Test that ansible-builder is installed
check "ansible-builder installed" command -v ansible-builder

# Test that ansible-lint is installed
check "ansible-lint installed" command -v ansible-lint

# Test that ansible-navigator is installed
check "ansible-navigator installed" command -v ansible-navigator

# Report result
reportResults