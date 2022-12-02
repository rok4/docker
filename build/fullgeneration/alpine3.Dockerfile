FROM alpine:3

RUN apt update && apt -y install curl procps wget gdal-bin

ARG ROK4TILEMATRIXSETS_VERSION=4.0
ENV ROK4TILEMATRIXSETS_VERSION=$ROK4TILEMATRIXSETS_VERSION
RUN curl -L -o rok4-tilematrixsets.deb  https://github.com/rok4/tilematrixsets/releases/download/${ROK4TILEMATRIXSETS_VERSION}/rok4-tilematrixsets-${ROK4TILEMATRIXSETS_VERSION}-linux-all.deb && apt install ./rok4-tilematrixsets.deb
ENV ROK4_TMS_DIRECTORY=/etc/rok4/tilematrixsets

ARG ROK4STYLES_VERSION=4.0
ENV ROK4STYLES_VERSION=$ROK4STYLES_VERSION
RUN curl -L -o rok4-styles.deb  https://github.com/rok4/styles/releases/download/${ROK4STYLES_VERSION}/rok4-styles-${ROK4STYLES_VERSION}-linux-all.deb && apt install ./rok4-styles.deb

ARG ROK4GENERATION_VERSION
ENV ROK4GENERATION_VERSION=$ROK4GENERATION_VERSION
RUN curl -L -o rok4-generation.deb  https://github.com/rok4/generation/releases/download/${ROK4GENERATION_VERSION}/rok4-generation-${ROK4GENERATION_VERSION}-ubuntu20.04-amd64.deb && apt install -y ./rok4-generation.deb

ARG ROK4COREPERL_VERSION
ENV ROK4COREPERL_VERSION=$ROK4COREPERL_VERSION
RUN curl -L -o librok4-core-perl.deb  https://github.com/rok4/core-perl/releases/download/${ROK4COREPERL_VERSION}/librok4-core-perl-${ROK4COREPERL_VERSION}-linux-all.deb && DEBIAN_FRONTEND=noninteractive apt install -y ./librok4-core-perl.deb

ARG ROK4PREGENERATION_VERSION
ENV ROK4PREGENERATION_VERSION=$ROK4PREGENERATION_VERSION
RUN curl -L -o rok4-pregeneration.deb  https://github.com/rok4/pregeneration/releases/download/${ROK4PREGENERATION_VERSION}/rok4-pregeneration-${ROK4PREGENERATION_VERSION}-linux-all.deb && apt install -y ./rok4-pregeneration.deb

ARG ROK4TOOLS_VERSION
ENV ROK4TOOLS_VERSION=$ROK4TOOLS_VERSION
RUN curl -L -o rok4-tools.deb  https://github.com/rok4/tools/releases/download/${ROK4TOOLS_VERSION}/rok4-tools-${ROK4TOOLS_VERSION}-linux-all.deb && apt install -y ./rok4-tools.deb

COPY --from=metacollin/tippecanoe:latest /usr/local/bin/tippecanoe /usr/bin/tippecanoe
ENV TIPPECANOE_VERSION=v1.36.0

CMD echo "ROK4:\n\t- generation: $ROK4GENERATION_VERSION\n\t- pregeneration: $ROK4PREGENERATION_VERSION\n\t- tools: $ROK4TOOLS_VERSION\n\t- core Perl: $ROK4COREPERL_VERSION\n\t- styles: $ROK4STYLES_VERSION\n\t- tile matrix sets: $ROK4TILEMATRIXSETS_VERSION\nTippecanoe: $TIPPECANOE_VERSION"
