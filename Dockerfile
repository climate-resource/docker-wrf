FROM ubuntu:22.04

MAINTAINER Jared Lewis <jared.lewis@climate-resource.com>

RUN apt-get update && \
    apt-get install -y sudo curl build-essential gfortran-12 m4 csh git jq wget aria2 imagemagick libmpich-dev && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash"]