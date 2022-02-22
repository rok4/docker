FROM debian:bullseye-slim

RUN apt update && apt -y install \
    perl-base git build-essential \
    libgdal-perl libpq-dev gdal-bin \
    libfile-find-rule-perl libfile-copy-link-perl \
    libconfig-ini-perl libdbi-perl libdbd-pg-perl libdevel-size-perl \
    libdigest-sha-perl libfile-map-perl libfindbin-libs-perl libhttp-message-perl liblwp-protocol-https-perl \
    libmath-bigint-perl libterm-progressbar-perl liblog-log4perl-perl libjson-parse-perl libjson-perl \
    libtest-simple-perl libxml-libxml-perl libamazon-s3-perl

ARG TAG
ARG GIT_HOST

RUN git clone --recursive --branch=${TAG} --depth=1 ${GIT_HOST}/rok4/pregeneration.git /pregeneration

# Installation des outils de prégénération
RUN cd /pregeneration && perl Makefile.PL INSTALL_BASE=/ VERSION=${TAG} && make && make injectversion && make install
RUN rm -r /pregeneration

# Déploiement des configurations
RUN git clone ${GIT_HOST}/rok4/styles.git /styles
RUN git clone ${GIT_HOST}/rok4/tilematrixsets.git /tilematrixsets

WORKDIR /