#!/bin/bash

mkdir -p scripts pyramids

tag="latest"
if [[ ! -z $1 ]]; then
    tag=$1
fi

### ORTHO (BE4)

if [[ -d ./pyramids/BDORTHO ]]; then
    rm -r ./pyramids/BDORTHO
fi

rm ./scripts/*
docker run --rm --name be4-ortho \
    --user $(id -u):$(id -g) \
    -v $PWD/confs:/confs:ro \
    -v $PWD/data:/data:ro \
    -v $PWD/pyramids:/pyramids \
    -v $PWD/scripts:/scripts \
    rok4/rok4generation:${tag} \
    /bin/bash -c "be4.pl --conf /confs/BDORTHO.main && bash /scripts/main.sh 10"


### ALTI (BE4)

if [[ -d ./pyramids/ALTI ]]; then
    rm -r ./pyramids/ALTI
fi

rm ./scripts/*
docker run --rm --name be4-alti \
    --user $(id -u):$(id -g) \
    -v $PWD/confs:/confs:ro \
    -v $PWD/data:/data:ro \
    -v $PWD/pyramids:/pyramids \
    -v $PWD/scripts:/scripts \
    rok4/rok4generation:${tag} \
    /bin/bash -c "be4.pl --conf /confs/ALTI.main && bash /scripts/main.sh 10"


### PENTE (BE4)

if [[ -d ./pyramids/PENTE ]]; then
    rm -r ./pyramids/PENTE
fi

rm ./scripts/*
docker run --rm --name be4-pente \
    --user $(id -u):$(id -g) \
    -v $PWD/confs:/confs:ro \
    -v $PWD/data:/data:ro \
    -v $PWD/pyramids:/pyramids \
    -v $PWD/scripts:/scripts \
    rok4/rok4generation:${tag} \
    /bin/bash -c "be4.pl --conf /confs/PENTE.main && bash /scripts/main.sh 10"

### LIMADM (4ALAMO)

if [[ -d ./pyramids/LIMADM ]]; then
    rm -r ./pyramids/LIMADM
fi

# POSTGIS
docker network create --driver=bridge --subnet=10.210.0.0/16 fouralamo-limadm

docker run --rm -d --name fouralamo-limadm-postgis \
    --network fouralamo-limadm \
    -e POSTGRES_DB=ign \
    -e POSTGRES_USER=ign \
    -e POSTGRES_PASSWORD=ign \
    -v $PWD/data/limadm.sql:/docker-entrypoint-initdb.d/limadm.sql \
    postgis/postgis:12-3.0-alpine

sleep 10

# 4ALAMO
rm ./scripts/*
docker run --rm -it --name test-rok4generation \
    --user $(id -u):$(id -g) \
    --network fouralamo-limadm \
    -v $PWD/confs:/confs:ro \
    -v $PWD/data:/data:ro \
    -v $PWD/pyramids:/pyramids \
    -v $PWD/scripts:/scripts \
    rok4/rok4generation:${tag} \
    /bin/bash -c "4alamo.pl --conf /confs/LIMADM.main && sleep 30 && bash /scripts/main.sh 10"

docker stop fouralamo-limadm-postgis
docker network rm fouralamo-limadm
