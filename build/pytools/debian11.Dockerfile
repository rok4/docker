FROM python:3.10-slim-bullseye

RUN apt update && apt -y install gdal-bin libgdal-dev curl g++

ARG ROK4TILEMATRIXSETS_VERSION=4.3
ENV ROK4TILEMATRIXSETS_VERSION=$ROK4TILEMATRIXSETS_VERSION
RUN curl -L -o rok4-tilematrixsets.deb  https://github.com/rok4/tilematrixsets/releases/download/${ROK4TILEMATRIXSETS_VERSION}/rok4-tilematrixsets-${ROK4TILEMATRIXSETS_VERSION}-linux-all.deb && apt install ./rok4-tilematrixsets.deb
ENV ROK4_TMS_DIRECTORY=/usr/share/rok4/tilematrixsets

ARG ROK4PYTOOLS_VERSION
ENV ROK4PYTOOLS_VERSION=$ROK4PYTOOLS_VERSION

WORKDIR /home
RUN pip install rok4-tools==$ROK4PYTOOLS_VERSION
RUN pip install GDAL=="$(gdal-config --version).*" && pip install gdal[numpy]=="$(gdal-config --version).*"

CMD echo "ROK4:\n\t- pytools: $ROK4PYTOOLS_VERSION\n\t- tile matrix sets: $ROK4TILEMATRIXSETS_VERSION"
