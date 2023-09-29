FROM ubuntu:20.04

RUN apt update && apt -y install curl procps wget gdal-bin

ARG ROK4TILEMATRIXSETS_VERSION=4.1
ENV ROK4TILEMATRIXSETS_VERSION=$ROK4TILEMATRIXSETS_VERSION
RUN curl -L -o rok4-tilematrixsets.deb  https://github.com/rok4/tilematrixsets/releases/download/${ROK4TILEMATRIXSETS_VERSION}/rok4-tilematrixsets-${ROK4TILEMATRIXSETS_VERSION}-linux-all.deb && apt install ./rok4-tilematrixsets.deb && rm ./rok4-tilematrixsets.deb
ENV ROK4_TMS_DIRECTORY=/usr/share/rok4/tilematrixsets

ARG ROK4COREPERL_VERSION
ENV ROK4COREPERL_VERSION=$ROK4COREPERL_VERSION
RUN curl -L -o librok4-core-perl.deb  https://github.com/rok4/core-perl/releases/download/${ROK4COREPERL_VERSION}/librok4-core-perl-${ROK4COREPERL_VERSION}-ubuntu-20.04-all.deb && DEBIAN_FRONTEND=noninteractive apt install -y ./librok4-core-perl.deb && rm ./librok4-core-perl.deb

COPY libnet-amazon-s3-perl_0.991-1_all.deb /libnet-amazon-s3-perl_0.991-1_all.deb
RUN curl -L -o libnet-amazon-s3-perl_0.991-1_all.deb http://snapshot.debian.org/archive/debian/20220718T213229Z/pool/main/libn/libnet-amazon-s3-perl/libnet-amazon-s3-perl_0.991-1_all.deb && apt install -y ./libnet-amazon-s3-perl_0.991-1_all.deb && rm ./libnet-amazon-s3-perl_0.991-1_all.deb

ARG ROK4PREGENERATION_VERSION
ENV ROK4PREGENERATION_VERSION=$ROK4PREGENERATION_VERSION
RUN curl -L -o rok4-pregeneration.deb  https://github.com/rok4/pregeneration/releases/download/${ROK4PREGENERATION_VERSION}/rok4-pregeneration-${ROK4PREGENERATION_VERSION}-ubuntu-20.04-all.deb && apt install -y ./rok4-pregeneration.deb && rm ./rok4-pregeneration.deb

CMD echo "ROK4:\n\t- pregeneration: $ROK4PREGENERATION_VERSION\n\t- core Perl: $ROK4COREPERL_VERSION\n\t- tile matrix sets: $ROK4TILEMATRIXSETS_VERSION"
