#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'ansible-tools' Feature with default options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "ansible-tools": {}
#    },
#    "remoteUser": "root"
# }
#
# Thus, the value of all options will fall back to the default values in the
# Feature's 'devcontainer-feature.json'.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib. Syntax is...
# check <LABEL> <cmd> [args...]

# Test 1: Verify ansible is installed
check "ansible installed" command -v ansible

# Test 2: Check ansible version
check "ansible version" bash -c "ansible --version | grep 'ansible \[core\]'"

# Test 3: Verify ansible-galaxy is installed
check "ansible-galaxy installed" command -v ansible-galaxy

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults