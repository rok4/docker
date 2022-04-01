FROM debian:bullseye-slim AS base

RUN apt update && apt -y install git gettext \
    libfcgi-dev \
    libtinyxml-dev \
    zlib1g-dev \
    libcurl4-openssl-dev \
    libproj-dev \
    libssl-dev \
    libturbojpeg0-dev \
    libjpeg-dev \
    libc6-dev \
    librados-dev \
    libjson11-1-dev \
    libboost-log-dev libboost-filesystem-dev libboost-system-dev \
    build-essential cmake
