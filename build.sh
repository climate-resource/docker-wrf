#!/bin/bash
set -e

echo "Checking input parameters."
if [ "$#" -ne 1 ]; then
    echo "Usage: build.sh region/your-region.json"
    exit 1
fi

region=$1

echo "Running build."
mkdir -p logs
packer build \
  -var-file secrets.json \
  -var-file $region \
  -var "git_sha=`git rev-parse --short HEAD`" \
  --only amazon-ebs template.json > >(tee logs/stdout-ebs.log) 2> >(tee logs/stderr-ebs.log >&2)