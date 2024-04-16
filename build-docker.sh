#!/bin/bash
set -xe

if [ "$#" -ne 0 ]; then
    echo "Usage: build-local.sh"
    exit 1
fi

echo "Building the latest version of the docker image"
docker build . -t wrf-image-base:latest

if [ -v CI_COMMIT_SHA ]; then
    GIT_SHA=${CI_COMMIT_SHA}
else
    GIT_SHA=`git rev-parse --short HEAD`
fi

echo "Running build."
mkdir -p logs

packer build \
  -var "git_sha=$GIT_SHA" \
  --only docker.wrf-base \
  template-docker.pkr.hcl > >(tee logs/stdout-local.log) 2> >(tee logs/stderr-local.log >&2)
