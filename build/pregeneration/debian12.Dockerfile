FROM ubuntu:22.04

RUN apt update && apt -y install curl procps wget gdal-bin

ARG ROK4TILEMATRIXSETS_VERSION=4.0
ENV ROK4TILEMATRIXSETS_VERSION=$ROK4TILEMATRIXSETS_VERSION
RUN curl -L -o rok4-tilematrixsets.deb  https://github.com/rok4/tilematrixsets/releases/download/${ROK4TILEMATRIXSETS_VERSION}/rok4-tilematrixsets-${ROK4TILEMATRIXSETS_VERSION}-linux-all.deb && apt install ./rok4-tilematrixsets.deb
ENV ROK4_TMS_DIRECTORY=/etc/rok4/tilematrixsets

ARG ROK4COREPERL_VERSION
ENV ROK4COREPERL_VERSION=$ROK4COREPERL_VERSION
RUN curl -L -o librok4-core-perl.deb  https://github.com/rok4/core-perl/releases/download/${ROK4COREPERL_VERSION}/librok4-core-perl-${ROK4COREPERL_VERSION}-ubuntu-20.04-all.deb && DEBIAN_FRONTEND=noninteractive apt install -y ./librok4-core-perl.deb

ARG ROK4PREGENERATION_VERSION
ENV ROK4PREGENERATION_VERSION=$ROK4PREGENERATION_VERSION
RUN curl -L -o rok4-pregeneration.deb  https://github.com/rok4/pregeneration/releases/download/${ROK4PREGENERATION_VERSION}/rok4-pregeneration-${ROK4PREGENERATION_VERSION}-ubuntu-20.04-all.deb && apt install -y ./rok4-pregeneration.deb

CMD echo "ROK4:\n\t- pregeneration: $ROK4PREGENERATION_VERSION\n\t- core Perl: $ROK4COREPERL_VERSION\n\t- tile matrix sets: $ROK4TILEMATRIXSETS_VERSION"
