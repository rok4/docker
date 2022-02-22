FROM tianon/true
MAINTAINER Théo Satabin <theo.satabin@ign.fr>

WORKDIR /

ADD . /pyramids/BDORTHO

VOLUME /pyramids/BDORTHO