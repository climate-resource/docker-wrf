FROM continuumio/miniconda3 as build

MAINTAINER Jared Lewis <jared.lewis@climate-resource.com>

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && \
    apt-get install -y curl m4 csh jq file && \
    rm -rf /var/lib/apt/lists/*

COPY environment.yml /opt/environment.yml
RUN conda env create -f /opt/environment.yml

# Install conda-pack:
RUN conda install -c conda-forge conda-pack

# Use conda-pack to create a standalone enviornment
# in /venv:
RUN conda-pack -n wrf -o /tmp/env.tar && \
  mkdir /opt/venv && cd /opt/venv && tar xf /tmp/env.tar && \
  rm /tmp/env.tar

# We've put venv in same path it'll be in final image,
# so now fix up paths:
RUN /opt/venv/bin/conda-unpack

COPY scripts /opt/wrf/build/scripts/
RUN PLATFORM=${TARGETPLATFORM} WRF_VERSION=${WRF_VERSION} WPS_VERSION=${WPS_VERSION} bash /opt/wrf/build/scripts/build_wrf.sh


FROM debian:bookworm AS runtime

ARG TARGETPLATFORM
ARG WRF_VERSION=4.5.1
ARG WPS_VERSION=4.5

WORKDIR /opt/wrf
COPY --from=build /opt/venv /opt/venv
COPY --from=build /opt/wrf /opt/wrf


ENTRYPOINT ["/bin/bash"]