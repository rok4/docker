FROM ubuntu:24.04

ENV OS_BUILDER=ubuntu-24.04

RUN apt update && apt -y install gettext libfcgi-dev libtinyxml-dev zlib1g-dev libcurl4-openssl-dev libproj-dev libssl-dev libturbojpeg0-dev \
            libjpeg-dev libc6-dev librados-dev libboost-log-dev libboost-filesystem-dev libboost-system-dev libopenjp2-7-dev \
            libproj-dev libsqlite3-dev build-essential cmake libtiff5-dev libpng-dev perl-base git

COPY build-artefact.sh /build-artefact.sh

RUN mkdir /artefacts
VOLUME /artefacts

ENTRYPOINT ["bash", "/build-artefact.sh"]
CMD ["help"]