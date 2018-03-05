#!/bin/bash
set -e

if [ "$#" -ne 0 ]; then
    echo "Usage: build-local.sh"
    exit 1
fi

echo "Building the latest version of the docker image"
docker build . -t augury-image-base:latest

echo "Running build."
mkdir -p logs
packer build -var-file secrets-local.json -var "git_sha=`git rev-parse --short HEAD`" --only docker template.json > >(tee logs/stdout-local.log) 2> >(tee logs/stderr-local.log >&2)