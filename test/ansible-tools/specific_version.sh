#!/bin/bash

# This test file will be executed against the 'specific_version' scenario in scenarios.json
# that includes 'ansible-tools' with ansibleVersion: "8.5.0"

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Test that ansible is installed with the specified version
check "ansible specific version" bash -c "ansible --version | grep -E 'ansible \[core 8\.5\.0\]'"

# Report result
reportResults