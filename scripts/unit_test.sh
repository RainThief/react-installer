#!/usr/bin/env bash
set -u

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)/../"

source "$PROJECT_ROOT/scripts/include.sh"

export NODE_ENV=test

ARGS=()
WATCH="false"

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c|--coverage)
    ARGS+=("--coverage")
    shift
    ;;
    -w|--watch)
    ARGS+=("--watch")
    WATCH="true"
    shift
    ;;
    *)
    ARGS+=("$1")
    shift
    ;;
esac
done

if [ "$WATCH" == "false" ]; then
    ARGS+=("--watchAll=false")
fi

set -- "${ARGS[@]}"

npx react-scripts test --watchAll=false "$@"
exitonfail $? "Unit tests"

echo_success "Unit tests passed"
