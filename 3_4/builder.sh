#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: ./builder.sh <github-repo> <docker-image>"
  exit 1
fi

if [ -z "$DOCKER_USER" ] || [ -z "$DOCKER_PWD" ]; then
  echo "Error: set DOCKER_USER and DOCKER_PWD environment variables"
  exit 1
fi

set -e

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

echo "$DOCKER_PWD" | docker login -u "$DOCKER_USER" --password-stdin
git clone "https://github.com/$1.git" "$WORKDIR/repo"
docker build -t "$2" "$WORKDIR/repo"
docker push "$2"
