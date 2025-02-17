FROM ubuntu:22.04

RUN apt update && apt -y install curl gettext

ARG ROK4TILEMATRIXSETS_VERSION=4.4
ENV ROK4TILEMATRIXSETS_VERSION=$ROK4TILEMATRIXSETS_VERSION
RUN curl -L -o rok4-tilematrixsets.deb  https://github.com/rok4/tilematrixsets/releases/download/${ROK4TILEMATRIXSETS_VERSION}/rok4-tilematrixsets-${ROK4TILEMATRIXSETS_VERSION}-linux-all.deb && apt install ./rok4-tilematrixsets.deb

ARG ROK4STYLES_VERSION=4.4
ENV ROK4STYLES_VERSION=$ROK4STYLES_VERSION
RUN curl -L -o rok4-styles.deb  https://github.com/rok4/styles/releases/download/${ROK4STYLES_VERSION}/rok4-styles-${ROK4STYLES_VERSION}-linux-all.deb && apt install ./rok4-styles.deb

ARG ROK4CORECPP_VERSION
ENV ROK4CORECPP_VERSION=$ROK4CORECPP_VERSION
RUN curl -L -o librok4-dev.deb https://github.com/rok4/core-cpp/releases/download/${ROK4CORECPP_VERSION}/librok4-ceph-${ROK4CORECPP_VERSION}-ubuntu-22.04-amd64.deb && apt install -y ./librok4-dev.deb

ARG ROK4SERVER_VERSION
ENV ROK4SERVER_VERSION=$ROK4SERVER_VERSION
RUN curl -L -o rok4-server.deb https://github.com/rok4/server/releases/download/${ROK4SERVER_VERSION}/rok4-server-${ROK4SERVER_VERSION}-ubuntu-22.04-amd64.deb && apt install -y ./rok4-server.deb

# Configuration par variables d'environnement par défaut
ENV ROK4_OBJECT_ATTEMPTS_WAIT=0
ENV IMPORT_LAYERS_FROM_PYRAMIDS=""
ENV SERVER_LOGLEVEL="debug" SERVER_LOGOUTPUT="standard_output" SERVER_NBTHREAD="4" SERVER_CACHE_SIZE="1000" SERVER_CACHE_VALIDITY="10" SERVER_BACKLOG="0"
ENV SERVER_LAYERS="/etc/rok4/layers.txt" SERVER_STYLES="/usr/share/rok4/styles" SERVER_TMS="/usr/share/rok4/tilematrixsets"

ENV SERVICE_TITLE="WMS/WMTS/TMS server"  SERVICE_ABSTRACT="This server provide WMS, WMTS and TMS raster and vector data broadcast"  SERVICE_PROVIDERNAME="ROK4 Team" SERVICE_PROVIDERSITE="https://github.com/rok4/documentation" SERVICE_KEYWORDS="WMS,WMTS,TMS,API Tiles,Docker"
ENV SERVICE_FEE="none" SERVICE_ACCESSCONSTRAINT="none"
ENV SERVICE_ADMIN_SUPPORT="true" SERVICE_COMMON_SUPPORT="true" SERVICE_WMTS_SUPPORT="true" SERVICE_TMS_SUPPORT="true" SERVICE_WMS_SUPPORT="true" SERVICE_TILES_SUPPORT="true"
ENV SERVICE_COMMON_ENDPOINT="http://localhost/common" SERVICE_WMTS_ENDPOINT="http://localhost/wmts" SERVICE_TMS_ENDPOINT="http://localhost/tms" SERVICE_WMS_ENDPOINT="http://localhost/wms" SERVICE_TILES_ENDPOINT="http://localhost/tiles"


WORKDIR /

# Déploiement des configurations
COPY ./server.template.json /etc/rok4/server.template.json
COPY ./services.template.json /etc/rok4/services.template.json

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

RUN mkdir /etc/rok4/layers /pyramids

RUN apt -y install valgrind

VOLUME /etc/rok4/layers
VOLUME /pyramids

RUN mkdir /configurations && chown rok4:rok4 /configurations

USER rok4

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["valgrind", "--leak-check=full", "/usr/bin/rok4", "-f", "/configurations/server.json"]
