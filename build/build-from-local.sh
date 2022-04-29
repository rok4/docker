#!/bin/bash

set -e

component=""
os="debian11"
tag=""
root=""
build_params=""

ARGUMENTS="os:,component:,proxy:,help,tag:,root:"
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
            echo "./build-from-local.sh <OPTIONS>"
            echo "    --os debian11"
            echo "    --root <CODE ROOT>"
            echo "    --tag <TAG>"
            echo "    --component server|generation|pregeneration|tools"
            echo "    --proxy http://proxy.chez.vous:port"
            exit 0
            ;;

        --os)
            os=$2
            shift 2
            ;;

        --tag)
            tag=$2
            shift 2
            ;;

        --root)
            root=$2
            shift 2
            ;;

        --component)
            component=$2
            shift 2
            ;;

        --proxy)
            build_params="$build_params --build-arg http_proxy=$2 --build-arg https_proxy=$2"
            shift 2
            ;;

        *)
            break
            ;;
    esac
done

if [[ -z $os ]]; then
    echo "No provided OS"
    exit 1
fi

if [[ -z $root ]]; then
    echo "No provided code root"
    exit 1
fi

if [[ -z $tag ]]; then
    echo "No provided tag"
    exit 1
fi

build_params="$build_params --build-arg TAG=$tag"

###### SERVER
if [[ "$component" == "server" ]]; then
    cp server/server.template.json server/services.template.json server/docker-entrypoint.sh $root/server/
    docker build -t rok4/server:${tag} -f server/${os}-from-local.Dockerfile $build_params $root/server
    rm $root/server/server.template.json $root/server/services.template.json $root/server/docker-entrypoint.sh
fi

###### GENERATION
if [[ "$component" == "generation" ]]; then
    docker build -t rok4/generation:${tag} -f generation/${os}-from-local.Dockerfile $build_params $root/generation
fi

###### PREGENERATION
if [[ "$component" == "pregeneration" ]]; then
    docker build -t rok4/pregeneration:${tag} -f pregeneration/${os}-from-local.Dockerfile $build_params $root/pregeneration
fi

###### TOOLS
if [[ "$component" == "tools" ]]; then
    docker build -t rok4/tools:${tag} -f tools/${os}-from-local.Dockerfile $build_params $root/tools
fi