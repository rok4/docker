COMPONENT=$1
VERSION=$2

if [[ -z $COMPONENT ]]; then
    echo "ERROR: component not provided"
    exit 1
fi


if [[ $COMPONENT == "help" ]]; then
    echo "Usage: docker run [...] rok4/builder:<os> server|generation|pregeneration|tools|core-perl|tilematrixsets|styles|tippecanoe <version>"
    exit 0
fi

if [[ -z $VERSION ]]; then
    echo "ERROR: version not provided"
    exit 1
fi

mkdir -p /sources
if [[ $COMPONENT == "server" ]]; then

    if [[ ! -d /sources/server/ ]]; then
        cd /sources
        git clone --branch $VERSION --depth 1 --recursive https://github.com/rok4/server
    fi
    cd mkdir -p /build && /build
    cmake -DOBJECT_ENABLED=1 -DCMAKE_INSTALL_PREFIX=/ -DCPACK_SYSTEM_NAME=$OS_BUILDER -DBUILD_VERSION=$VERSION /sources/server/
    make
    make package
    mv rok4-server-* /artefacts

elif [[ $COMPONENT == "generation" ]]; then

    if [[ ! -d /sources/generation/ ]]; then
        cd /sources
        git clone --branch $VERSION --depth 1 --recursive https://github.com/rok4/generation
    fi
    cd mkdir -p /build && /build
    cmake -DOBJECT_ENABLED=1 -DCMAKE_INSTALL_PREFIX=/ -DCPACK_SYSTEM_NAME=$OS_BUILDER -DBUILD_VERSION=$VERSION /sources/generation/
    make
    make package
    mv rok4-generation-* /artefacts

elif [[ $COMPONENT == "pregeneration" ]]; then

    if [[ ! -d /sources/pregeneration/ ]]; then
        cd /sources
        git clone --branch $VERSION --depth 1 --recursive https://github.com/rok4/pregeneration
    fi

    cd mkdir -p /rok4-pregeneration-$VERSION-linux-all
    cd /sources/pregeneration/
    perl Makefile.PL DESTDIR=/rok4-pregeneration-$VERSION-linux-all INSTALL_BASE=/ VERSION=$VERSION
    make
    make injectversion
    make pure_install

    tar cvfz /artefacts/rok4-pregeneration-$VERSION-linux-all.tar.gz -C / rok4-pregeneration-$VERSION-linux-all

    if [[ $OS_BUILDER == "debian11" || $OS_BUILDER == "debian12" ]]; then
        cd /rok4-pregeneration-$VERSION-linux-all
        mkdir DEBIAN
cat > DEBIAN/control << EOM
Package: rok4-pregeneration
Version: $VERSION
Maintainer: Géoportail<tout_rdev@ign.fr>
Architecture: all
Description: ROK4 data pregeneration tools scan data, identify work to do and write scripts to generate data pyramids
Depends: perl-base, librok4-core-perl, libfindbin-libs-perl, libmath-bigint-perl, liblog-log4perl-perl, libjson-parse-perl, libjson-perl
EOM

        dpkg-deb --build /rok4-pregeneration-$VERSION-linux-all /artefacts/rok4-pregeneration-$VERSION-linux-all.deb
    fi

elif [[ $COMPONENT == "tools" ]]; then

    if [[ ! -d /sources/tools/ ]]; then
        cd /sources
        git clone --branch $VERSION --depth 1 --recursive https://github.com/rok4/tools
    fi

    cd mkdir -p /rok4-tools-$VERSION-linux-all
    cd /sources/tools/
    perl Makefile.PL DESTDIR=/rok4-tools-$VERSION-linux-all INSTALL_BASE=/ VERSION=$VERSION
    make
    make injectversion
    make pure_install

    tar cvfz /artefacts/rok4-tools-$VERSION-linux-all.tar.gz -C / rok4-tools-$VERSION-linux-all

    if [[ $OS_BUILDER == "debian11" || $OS_BUILDER == "debian12" ]]; then
        cd /rok4-tools-$VERSION-linux-all
        mkdir DEBIAN
cat > DEBIAN/control << EOM
Package: rok4-tools
Version: $VERSION
Maintainer: Géoportail<tout_rdev@ign.fr>
Architecture: all
Description: ROK4 managment tools allow to scan or delete data pyramids and generate default layer files
Depends: perl-base, librok4-core-perl, libfindbin-libs-perl, libterm-progressbar-perl, liblog-log4perl-perl, libjson-parse-perl, libjson-perl
EOM

        dpkg-deb --build /rok4-tools-$VERSION-linux-all /artefacts/rok4-tools-$VERSION-linux-all.deb
    fi

elif [[ $COMPONENT == "core-perl" ]]; then

    if [[ ! -d /sources/core-perl/ ]]; then
        cd /sources
        git clone --branch $VERSION --depth 1 --recursive https://github.com/rok4/core-perl
    fi

    cd mkdir -p /librok4-core-perl-$VERSION-linux-all
    cd /sources/core-perl/
    perl Makefile.PL DESTDIR=/librok4-core-perl-$VERSION-linux-all INSTALL_BASE=/ VERSION=$VERSION
    make
    make pure_install

    tar cvfz /artefacts/librok4-core-perl-$VERSION-linux-all.tar.gz -C / librok4-core-perl-$VERSION-linux-all

    if [[ $OS_BUILDER == "debian11" || $OS_BUILDER == "debian12" ]]; then
        cd /librok4-core-perl-$VERSION-linux-all
        mkdir DEBIAN
cat > DEBIAN/control << EOM
Package: librok4-core-perl
Version: $VERSION
Maintainer: Géoportail<tout_rdev@ign.fr>
Architecture: all
Description: Perl core libraries are used by ROK4 pregeneration and managment tools
Depends: perl-base, libpq-dev, gdal-bin, libfile-find-rule-perl, libfile-copy-link-perl, libconfig-ini-perl, libdbi-perl, libdbd-pg-perl, libdevel-size-perl, libdigest-sha-perl, libfile-map-perl, libfindbin-libs-perl, libhttp-message-perl, liblwp-protocol-https-perl, libmath-bigint-perl, libterm-progressbar-perl, liblog-log4perl-perl, libjson-parse-perl, libjson-perl, libjson-validator-perl, libtest-simple-perl, libxml-libxml-perl, libnet-amazon-s3-perl
EOM

        dpkg-deb --build /librok4-core-perl-$VERSION-linux-all /artefacts/librok4-core-perl-$VERSION-linux-all.deb
    fi

elif [[ $COMPONENT == "tilematrixsets" ]]; then

    if [[ ! -d /sources/tilematrixsets/ ]]; then
        cd /sources
        git clone --branch $VERSION --depth 1 --recursive https://github.com/rok4/tilematrixsets
    fi

    mkdir -p /rok4-tilematrixsets-$VERSION-linux-all/etc/rok4/tilematrixsets
    cp /sources/tilematrixsets/*.json /rok4-tilematrixsets-$VERSION-linux-all/etc/rok4/tilematrixsets/

    tar cvfz /artefacts/rok4-tilematrixsets-$VERSION-linux-all.tar.gz -C / rok4-tilematrixsets-$VERSION-linux-all

    if [[ $OS_BUILDER == "debian11" || $OS_BUILDER == "debian12" ]]; then
        cd /rok4-tilematrixsets-$VERSION-linux-all/
        mkdir DEBIAN
cat > DEBIAN/control << EOM
Package: rok4-tilematrixsets
Version: $VERSION
Maintainer: Géoportail<tout_rdev@ign.fr>
Architecture: all
Description: Tile Matrix Sets define grids to process then broadcast geographical data as tile
EOM

        dpkg-deb --build /rok4-tilematrixsets-$VERSION-linux-all /artefacts/rok4-tilematrixsets-$VERSION-linux-all.deb
    fi

elif [[ $COMPONENT == "styles" ]]; then

    if [[ ! -d /sources/styles/ ]]; then
        cd /sources
        git clone --branch $VERSION --depth 1 --recursive https://github.com/rok4/styles
    fi

    mkdir -p /rok4-styles-$VERSION-linux-all/etc/rok4/styles
    cp /sources/styles/*.json /rok4-styles-$VERSION-linux-all/etc/rok4/styles/

    tar cvfz /artefacts/rok4-styles-$VERSION-linux-all.tar.gz -C / rok4-styles-$VERSION-linux-all

    if [[ $OS_BUILDER == "debian11" || $OS_BUILDER == "debian12" ]]; then
        cd /rok4-styles-$VERSION-linux-all/
        mkdir DEBIAN
cat > DEBIAN/control << EOM
Package: rok4-styles
Version: $VERSION
Maintainer: Géoportail<tout_rdev@ign.fr>
Architecture: all
Description: Styles are used by processing tools and server to transform raster data
EOM

        dpkg-deb --build /rok4-styles-$VERSION-linux-all /artefacts/rok4-styles-$VERSION-linux-all.deb
    fi

elif [[ $COMPONENT == "tippecanoe" ]]; then

    cd /sources
    git clone --branch $VERSION --depth 1 https://github.com/mapbox/tippecanoe.git

    cd tippecanoe
    if [[ $OS_BUILDER == "alpine3" ]]; then
        sed -i "s#SHELL = /bin/bash#SHELL = /bin/ash#" Makefile
    fi
    make -j
    mv tippecanoe /artefacts/tippecanoe-$VERSION-$OS_BUILDER
fi
