FROM ubuntu:latest

MAINTAINER Jared Lewis <jared@jared.kiwi.nz>

RUN apt-get update && apt-get install sudo && rm -rf /var/lib/apt/lists/*
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN useradd --create-home -s /bin/bash ubuntu
USER ubuntu

WORKDIR /home/ubuntu

RUN mkdir ~/.ssh && chmod 700 ~/.ssh