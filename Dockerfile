FROM ubuntu:22.04 as base

MAINTAINER Jared Lewis <jared.lewis@climate-resource.com>

RUN apt-get update && \
    apt-get install -y sudo curl build-essential libstdc++-12-dev gfortran-12 m4 csh git jq wget aria2 imagemagick libmpich-dev && \
    rm -rf /var/lib/apt/lists/*

FROM base as build

ARG TARGETPLATFORM
ENV WRF_VERSION=4.2
ENV WPS_VERSION=4.2


COPY scripts /opt/wrf/build/scripts/

WORKDIR /opt/wrf

RUN PLATFORM=${TARGETPLATFORM} bash /opt/wrf/build/scripts/install_deps.sh
RUN PLATFORM=${TARGETPLATFORM} bash /opt/wrf/build/scripts/build_wrf.sh

ENTRYPOINT ["/bin/bash"]