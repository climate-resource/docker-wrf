#!/bin/bash
set -xe

if [ "$#" -ne 0 ]; then
    echo "Usage: build-local.sh"
    exit 1
fi

# Set the platform to target for the docker container
# If running on arm64, set PLATFORM=linux/arm64 before running
# i.e. PLATFORM=linux/arm64 bash ./build-docker.sh
PLATFORM="${PLATFORM:-linux/amd64}"

echo "Building the latest version of the docker image"
docker build --platform $PLATFORM . -t ghcr.io/climate-resource/wrf-base:latest

if [ -v CI_COMMIT_SHA ]; then
    GIT_SHA=${CI_COMMIT_SHA}
else
    GIT_SHA=`git rev-parse --short HEAD`
fi

echo "Running build."
mkdir -p logs

packer build \
  -var "git_sha=$GIT_SHA" \
  -var "platform=$PLATFORM" \
  --only docker.wrf-base \
  template-docker.pkr.hcl > >(tee logs/stdout-local.log) 2> >(tee logs/stderr-local.log >&2)
