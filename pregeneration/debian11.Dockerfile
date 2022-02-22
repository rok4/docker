FROM debian:bullseye-slim

RUN apt update && apt -y install \
    perl-base git \
    libgdal-perl libpq-dev gdal-bin \
    libfile-find-rule-perl libfile-copy-link-perl \
    libconfig-ini-perl libdbi-perl libdbd-pg-perl libdevel-size-perl \
    libdigest-sha-perl libfile-map-perl libfindbin-libs-perl libhttp-message-perl liblwp-protocol-https-perl \
    libmath-bigint-perl libterm-progressbar-perl liblog-log4perl-perl libjson-parse-perl libjson-perl \
    libtest-simple-perl libxml-libxml-perl libamazon-s3-perl

ARG TAG=0.0.0
RUN git clone --branch=${TAG} --recursive --depth=1 http://gitlab.forge-geoportail.ign.fr/rok4/pregeneration.git /pregeneration

# Installation des libs ROK4::Core
RUN git clone --branch=${TAG} --recursive --depth=1 http://gitlab.forge-geoportail.ign.fr/rok4/core-perl.git /core-perl
RUN cd /core-perl && perl Makefile.PL INSTALL_BASE=/ VERSION=${TAG} && make install
RUN rm -r /core-perl

# Installation des outils de prégénération
RUN cd /pregeneration && perl Makefile.PL INSTALL_BASE=/ VERSION=${TAG} && make install
RUN rm -r /pregeneration

WORKDIR /
