FROM ubuntu:20.04

RUN apt update && apt -y install curl procps wget gdal-bin

ARG ROK4STYLES_VERSION=4.0
ENV ROK4STYLES_VERSION=$ROK4STYLES_VERSION
RUN curl -L -o rok4-styles.deb  https://github.com/rok4/styles/releases/download/${ROK4STYLES_VERSION}/rok4-styles_${ROK4STYLES_VERSION}_all.deb && apt install ./rok4-styles.deb

ARG ROK4GENERATION_VERSION
ENV ROK4GENERATION_VERSION=$ROK4GENERATION_VERSION
RUN curl -L -o rok4-generation.deb  https://github.com/rok4/generation/releases/download/${ROK4GENERATION_VERSION}/rok4-generation_${ROK4GENERATION_VERSION}_amd64.deb && apt install -y ./rok4-generation.deb

ARG ROK4COREPERL_VERSION
ENV ROK4COREPERL_VERSION=$ROK4COREPERL_VERSION
RUN curl -L -o librok4-core-perl.deb  https://github.com/rok4/core-perl/releases/download/${ROK4COREPERL_VERSION}/librok4-core-perl_${ROK4COREPERL_VERSION}_all.deb && DEBIAN_FRONTEND=noninteractive apt install -y ./librok4-core-perl.deb

COPY --from=metacollin/tippecanoe:latest /usr/local/bin/tippecanoe /usr/bin/tippecanoe
ENV TIPPECANOE_VERSION=v1.36.0

CMD echo "ROK4:\n\t- generation: $ROK4GENERATION_VERSION\n\t- core Perl: $ROK4COREPERL_VERSION\n\t- styles: $ROK4STYLES_VERSION\nTippecanoe: $TIPPECANOE_VERSION"
