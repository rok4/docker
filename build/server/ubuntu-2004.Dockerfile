FROM ubuntu:20.04

RUN apt update && apt -y install curl gettext

ARG ROK4TILEMATRIXSETS_VERSION=4.0
ENV ROK4TILEMATRIXSETS_VERSION=$ROK4TILEMATRIXSETS_VERSION
RUN curl -L -o rok4-tilematrixsets.deb  https://github.com/rok4/tilematrixsets/releases/download/${ROK4TILEMATRIXSETS_VERSION}/rok4-tilematrixsets-${ROK4TILEMATRIXSETS_VERSION}-linux-all.deb && apt install ./rok4-tilematrixsets.deb

ARG ROK4STYLES_VERSION=4.0
ENV ROK4STYLES_VERSION=$ROK4STYLES_VERSION
RUN curl -L -o rok4-styles.deb  https://github.com/rok4/styles/releases/download/${ROK4STYLES_VERSION}/rok4-styles-${ROK4STYLES_VERSION}-linux-all.deb && apt install ./rok4-styles.deb

ARG ROK4CORECPP_VERSION
ENV ROK4CORECPP_VERSION=$ROK4CORECPP_VERSION
RUN curl -L -o librok4-dev.deb https://github.com/rok4/core-cpp/releases/download/${ROK4CORECPP_VERSION}/librok4-ceph-${ROK4CORECPP_VERSION}-ubuntu-20.04-amd64.deb && apt install -y ./librok4-dev.deb

ARG ROK4SERVER_VERSION
ENV ROK4SERVER_VERSION=$ROK4SERVER_VERSION
RUN curl -L -o rok4-server.deb https://github.com/rok4/server/releases/download/${ROK4SERVER_VERSION}/rok4-server-${ROK4SERVER_VERSION}-ubuntu-20.04-amd64.deb && apt install -y ./rok4-server.deb

# Configuration par variables d'environnement par défaut
ENV IMPORT_LAYERS_FROM_PYRAMIDS=""
ENV SERVER_LOGLEVEL="error" SERVER_LOGOUTPUT="standard_output" SERVER_NBTHREAD="4" SERVER_CACHE_SIZE="1000" SERVER_CACHE_VALIDITY="10" SERVER_BACKLOG="0"
ENV SERVER_LAYERS="/etc/rok4/layers.txt" SERVER_STYLES="/usr/share/rok4/styles" SERVER_TMS="/usr/share/rok4/tilematrixsets"
ENV SERVICE_TITLE="WMS/WMTS/TMS server"  SERVICE_ABSTRACT="This server provide WMS, WMTS and TMS raster and vector data broadcast"  SERVICE_PROVIDERNAME="ROK4 Team" SERVICE_PROVIDERSITE="https://github.com/rok4/documentation" SERVICE_KEYWORDS="WMS,WMTS,TMS,Docker"
ENV SERVICE_FEE="none" SERVICE_ACCESSCONSTRAINT="none"
ENV SERVICE_WMS="WMS service" SERVICE_MAXWIDTH="10000" SERVICE_MAXHEIGHT="10000" SERVICE_LAYERLIMIT="2" SERVICE_MAXTILEX="256" SERVICE_MAXTILEY="256" SERVICE_FORMATLIST="image/jpeg,image/png,image/tiff,image/geotiff,image/x-bil;bits=32"
ENV SERVICE_GLOBALCRSLIST="CRS:84,EPSG:3857" SERVICE_FULLYSTYLING="true" SERVICE_INSPIRE="false"
ENV SERVICE_WMTSSUPPORT="true" SERVICE_TMSSUPPORT="true" SERVICE_WMSSUPPORT="true"
ENV SERVICE_WMTS_ENDPOINT="http://localhost/wmts" SERVICE_TMS_ENDPOINT="http://localhost/tms" SERVICE_WMS_ENDPOINT="http://localhost/wms"

WORKDIR /

# Déploiement des configurations
COPY ./server.template.json /etc/rok4/server.template.json
COPY ./services.template.json /etc/rok4/services.template.json

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

RUN mkdir /etc/rok4/layers /pyramids

VOLUME /etc/rok4/layers
VOLUME /pyramids

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/rok4", "-f", "/etc/rok4/server.json"]
