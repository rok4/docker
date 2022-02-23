#!/bin/bash

set -e

conf_name=""
pyr_dir_name=""
dockerfile_name=""
image_name=""

run_pregeneration=0
run_generation=0
build_image=0
build_layer=0

tag=""

ARGUMENTS="image,layer,ortho,alti,pente,help,tag:,pregeneration,generation,all"
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
            echo "    --tag <TAG>"
            echo "    --all"
            echo "    --pregeneration"
            echo "    --generation"
            echo "    --layer"
            echo "    --image"
            echo ""
            echo "    --ortho"
            echo "    --alti"
            echo "    --pente"
            exit 0
            ;;

        --tag)
            tag=$2
            shift 2
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

        --ortho)
            conf_name="BDORTHO.main"
            pyr_dir_name="BDORTHO"
            dockerfile_name="BDORTHO.Dockerfile"
            image_name="rok4/dataset:bdortho5m-martinique"
            shift 1
            ;;

        --ortho)
            conf_name="BDORTHO.main"
            pyr_dir_name="BDORTHO"
            dockerfile_name="BDORTHO.Dockerfile"
            image_name="rok4/dataset:bdortho5m-martinique"
            shift 1
            ;;

        --alti)
            conf_name="ALTI.main"
            pyr_dir_name="ALTI"
            dockerfile_name="ALTI.Dockerfile"
            image_name="rok4/dataset:bdalti-martinique"
            shift 1
            ;;

        --pente)
            conf_name="PENTE.main"
            pyr_dir_name="PENTE"
            dockerfile_name="PENTE.Dockerfile"
            image_name="rok4/dataset:pente-martinique"
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

if [[ -z $tag ]]; then
    tag="latest"
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
        -v $PWD/confs:/confs:ro \
        -v $PWD/downloads:/data:ro \
        -v $PWD/pyramids:/pyramids \
        -v $PWD/scripts:/scripts \
        -v $PWD/common:/common \
        rok4/pregeneration:${tag} \
        be4.pl --conf /confs/$conf_name
fi

if [[ "$run_generation" == "1" ]]; then
    echo "Génération"
    docker run --rm --name gen \
        --user $(id -u):$(id -g) \
        -v $PWD/downloads:/data:ro \
        -v $PWD/pyramids:/pyramids \
        -v $PWD/scripts:/scripts \
        -v $PWD/common:/common \
        rok4/generation:${tag} \
        bash /scripts/main.sh 10
fi

if [[ "$build_layer" == "1" ]]; then
    echo "Descripteur de couche"
    docker run --rm --name lay \
        --user $(id -u):$(id -g) \
        -v $PWD/pyramids:/pyramids \
        rok4/tools:${tag} \
        bash -c "create-layer.pl --pyramid file:///pyramids/${pyr_dir_name}/${pyr_dir_name}.json >/pyramids/${pyr_dir_name}/${pyr_dir_name}.lay.json"
fi

if [[ "$build_image" == "1" ]]; then
    echo "Compilation de l'image docker"
    docker build -t ${image_name} -f confs/${dockerfile_name} pyramids/${pyr_dir_name}
fi

exit 0