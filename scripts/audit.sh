#!/usr/bin/env bash
set -uo pipefail

source "./scripts/include.sh"

ALLOWED_LICENSES="$(< ./node_modules/@rainthief/react-lint-config/licenses.json jq -c -r '.[]' | tr '\n' ';')"
if [ "$ALLOWED_LICENSES" == "" ]; then
    exitonfail 1 "License list import"
fi

npx license-checker --excludePrivatePackages --onlyAllow "$ALLOWED_LICENSES"
exitonfail $? "License check"

yarn audit
EXIT=$?

yarn outdated
warnonfail $? "Not all dependencies up to date"

if [ $EXIT -gt 3 ]; then
    echo_danger "Security audit failed"
    exit 1
fi
if [ $EXIT -gt 0 ]; then
    echo_warning "Security audit passed with warnings"
    exit 0
fi

echo_success "Audit passed"
