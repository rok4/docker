FROM alpine:3

ENV OS_BUILDER=alpine3

RUN apk add --no-cache autoconf build-base binutils cmake gcc g++ libgcc libtool linux-headers make wget git zlib-dev boost-dev proj-dev openjpeg-dev libpng-dev librados ceph-dev glib-dev tinyxml-dev fcgi-dev
RUN wget -O json11.zip  https://github.com/dropbox/json11/archive/refs/tags/v1.0.0.zip && unzip json11.zip && cd json11-1.0.0/ && cmake . && make && make install

COPY build-artefact.sh /build-artefact.sh

RUN mkdir /artefacts
VOLUME /artefacts

ENTRYPOINT ["ash", "/build-artefact.sh"]
CMD ["help"]