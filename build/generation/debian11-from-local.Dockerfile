

FROM debian:bullseye-slim AS base

# Installation des librairies

RUN apt update && apt -y install \
    curl git \
    libopenjp2-7-dev \
    zlib1g-dev \
    libtiff5-dev \
    libpng-dev \
    libcurl4-openssl-dev \
    libproj-dev \
    libssl-dev \
    libturbojpeg0-dev \
    libjpeg-dev \
    libc6-dev \
    librados-dev \
    libjson11-1-dev \
    libboost-log-dev libboost-filesystem-dev libboost-system-dev libsqlite3-dev

#### Compilation de l'application

FROM base AS builder

# Environnement de compilation

RUN apt update && apt -y install build-essential cmake

# Compilation des outils de génération

ARG TAG
COPY . /generation

RUN mkdir -p /build
WORKDIR /build

RUN cmake -DCMAKE_INSTALL_PREFIX=/ -DBUILD_VERSION=${TAG} -DOBJECT_ENABLED=1 /generation/
RUN make && make package

# Compilation de tippecanoe

RUN git clone --depth=1 https://github.com/mapbox/tippecanoe.git /tippecanoe

WORKDIR /tippecanoe
RUN make -j && make install

#### Image de run

FROM base

ARG TAG

WORKDIR /

# Récupération des exécutables
COPY --from=builder /usr/local/bin/tippecanoe /bin/tippecanoe
COPY --from=builder /build/ROK4GENERATION-${TAG}-Linux-64bit.tar.gz /

RUN apt update && apt -y install procps wget gdal-bin
RUN tar xvzf /ROK4GENERATION-${TAG}-Linux-64bit.tar.gz --strip-components=1

# Déploiement des configurations
RUN git clone https://github.com/rok4/styles.git /styles

CMD ls -l /bin
