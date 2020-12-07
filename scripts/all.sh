#!/usr/bin/env bash
set -eu

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)/../"

source "$PROJECT_ROOT/scripts/include.sh"

_pushd "${PROJECT_ROOT}"

echo_info "\nRunning Static Analysis"
./scripts/static_analysis.sh

echo_info "\nRunning Unit Tests"
./scripts/unit_tests.sh -c

echo_info "\nRunning Audit"
./scripts/audit.sh

echo_success "All checks/tests successful"

_popd
