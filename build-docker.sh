#!/bin/bash
set -e

if [ "$#" -ne 0 ]; then
    echo "Usage: build-local.sh"
    exit 1
fi

echo "Building the latest version of the docker image"
docker build . -t augury-image-base:latest

if [ -z "$CI_COMMIT_SHA" ]; then
    GIT_SHA=${CI_COMMIT_SHA}
else
    GIT_SHA=`git rev-parse --short HEAD`

echo "Running build."
mkdir -p logs
packer build -var "git_sha=$GIT_SHA" --only docker template-docker.json > >(tee logs/stdout-local.log) 2> >(tee logs/stderr-local.log >&2)