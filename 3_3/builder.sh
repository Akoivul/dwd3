#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: ./builder.sh <github-repo> <docker-image>"
  exit 1
fi

set -e

GITHUB_REPO="$1"
DOCKER_IMAGE="$2"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

echo "Cloning https://github.com/$GITHUB_REPO ..."
git clone "https://github.com/$GITHUB_REPO.git" "$WORKDIR/repo"

echo "Building image $DOCKER_IMAGE ..."
docker build -t "$DOCKER_IMAGE" "$WORKDIR/repo"

echo "Pushing $DOCKER_IMAGE to Docker Hub ..."
docker push "$DOCKER_IMAGE"

echo "Done: $GITHUB_REPO built and pushed as $DOCKER_IMAGE"