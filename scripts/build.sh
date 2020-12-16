#!/usr/bin/env bash
set -eu

CI=${CI:-"false"}

IMAGE_NAME="docker.pkg.github.com/rainthief/react-installer/react-spa"

# Assume this script is in the src directory and work from that location
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)/../"


pushd "$PROJECT_ROOT"

if [ "$CI" == "true" ]; then
    # login here as base image private
    docker login "$DOCKER_REG" -u "$DOCKER_USER" -p "$DOCKER_PASS"
fi

docker build --pull -t "$IMAGE_NAME" --build-arg GITHUB_TOKEN .

if [ "$CI" == "true" ]; then
    GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    BRANCH_TAG="${GIT_BRANCH//\//--}"

    docker tag "$IMAGE_NAME" "$IMAGE_NAME:$BRANCH_TAG"

    docker push "$IMAGE_NAME:$BRANCH_TAG"

    if [ "$GIT_BRANCH" == "master" ]; then
        # shellcheck disable=SC1091
        source "./scripts/semver.sh"
        RELEASE_TAG="$(get_tag "patch")"
        docker tag "$IMAGE_NAME" "$IMAGE_NAME:$RELEASE_TAG"
        docker push "$IMAGE_NAME"
    fi
fi
