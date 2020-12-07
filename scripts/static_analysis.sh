#!/usr/bin/env bash
set -uo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)/../"

source "$PROJECT_ROOT/scripts/include.sh"

ESLINT_OPT="--fix"

if [ "$CI" == "true" ]; then
    ESLINT_OPT="--quiet"
fi

echo_info "linting javascript"
npx eslint "$ESLINT_OPT" --color ./src -c .eslintrc.js --ext .ts,.tsx,.js,.jsx
exitonfail $? "Eslint"

echo_info "linting sass"
npx stylelint --color "**/*.{css,scss,sass}"
exitonfail $? "Stylelint"

echo_info "linting bash"
shellcheck ./*.sh
exitonfail $? "shellcheck"

shellcheck ./scripts/*.sh
exitonfail $? "shellcheck"

echo_info "linting dockerfile"
hadolint ./scripts/Dockerfile
exitonfail $? "hadolint"

echo_success "Static analysis passed"
