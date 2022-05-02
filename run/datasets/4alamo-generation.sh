#!/bin/bash

set -e

conf_name=""
pyr_dir_name=""
sql_file=""
dockerfile_name=""
image_name=""

run_pregeneration=0
run_generation=0
build_image=0
build_layer=0

ARGUMENTS="image,layer,pregeneration,generation,all,limadm,help"
# read arguments
opts=$(getopt \
    --longoptions "${ARGUMENTS}" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)
eval set --$opts

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)
            echo "./build.sh <OPTIONS>"
            echo "    --all"
            echo "    --pregeneration"
            echo "    --generation"
            echo "    --layer"
            echo "    --image"
            echo ""
            echo "    --limadm"
            exit 0
            ;;

        --pregeneration)
            run_pregeneration=1
            shift 1
            ;;

        --generation)
            run_generation=1
            shift 1
            ;;

        --all)
            run_pregeneration=1
            run_generation=1
            build_image=1
            build_layer=1
            shift 1
            ;;

        --image)
            build_image=1
            shift 1
            ;;

        --layer)
            build_layer=1
            shift 1
            ;;

        --limadm)
            conf_name="LIMADM.json"
            pyr_dir_name="LIMADM"
            sql_file="limadm.sql"
            dockerfile_name="LIMADM.Dockerfile"
            image_name="rok4/dataset:geofla-martinique"
            shift 1
            ;;

        *)
            break
            ;;
    esac
done

if [[ -z $conf_name ]]; then
    echo "Pas de génération demandée"
    exit 0
fi

mkdir -p scripts pyramids common

if [[ "$run_pregeneration" == "1" || "$run_generation" == "1" ]]; then
    echo "Lancement de la BDD"
    docker network create --driver=bridge --subnet=10.210.0.0/16 fouralamo-net
    docker run --rm -d --name bdd \
        --network fouralamo-net \
        -e POSTGRES_DB=ign \
        -e POSTGRES_USER=ign \
        -e POSTGRES_PASSWORD=ign \
        -v $PWD/data/${sql_file}:/docker-entrypoint-initdb.d/${sql_file} \
        postgis/postgis:12-3.0-alpine

    sleep 10
fi

if [[ "$run_pregeneration" == "1" ]]; then
    echo "Nettoyage"
    if [[ -d ./pyramids/${pyr_dir_name} ]]; then
        rm -r ./pyramids/${pyr_dir_name}
    fi
    rm -rf ./scripts/* ./common/*

    echo "Prégénération"
    docker run --rm --name pregen \
        --user $(id -u):$(id -g) \
        --network fouralamo-net \
        -v $PWD/confs:/confs:ro \
        -v $PWD/downloads:/data:ro \
        -v $PWD/pyramids:/pyramids \
        -v $PWD/scripts:/scripts \
        -v $PWD/common:/common \
        rok4/pregeneration \
        4alamo.pl --conf /confs/$conf_name
fi

if [[ "$run_generation" == "1" ]]; then
    echo "Génération"

    docker run --rm --name gen \
        --user $(id -u):$(id -g) \
        --network fouralamo-net \
        -v $PWD/downloads:/data:ro \
        -v $PWD/pyramids:/pyramids \
        -v $PWD/scripts:/scripts \
        -v $PWD/common:/common \
        rok4/generation \
        bash /scripts/main.sh 10
fi

if [[ "$run_pregeneration" == "1" || "$run_generation" == "1" ]]; then
    echo "Extinction de la BDD et nettoyage"
    docker stop bdd
    docker network rm fouralamo-net
fi

if [[ "$build_layer" == "1" ]]; then
    echo "Descripteur de couche"
    docker run --rm --name lay \
        --user $(id -u):$(id -g) \
        -v $PWD/pyramids:/pyramids \
        rok4/tools \
        bash -c "create-layer.pl --pyramid file:///pyramids/${pyr_dir_name}/${pyr_dir_name}.json >/pyramids/${pyr_dir_name}/${pyr_dir_name}.lay.json"
fi

if [[ "$build_image" == "1" ]]; then
    echo "Compilation de l'image docker"
    docker build -t ${image_name} -f confs/${dockerfile_name} pyramids/${pyr_dir_name}
fi

exit 0
