FROM ubuntu:22.04

MAINTAINER Jared Lewis <jared.lewis@climate-resource.com>

RUN apt-get update && apt-get install -y sudo curl && rm -rf /var/lib/apt/lists/*
