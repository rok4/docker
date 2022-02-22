#!/bin/bash

set -e

server="0"
generation="0"
pregeneration="0"
os=""
tag=""
git_host="http://gitlab.forge-geoportail.ign.fr"
build_params=""

ARGUMENTS="os:,server,generation,pregeneration,proxy:,help,tag:"
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
            echo "    --os debian11"
            echo "    --tag <TAG>"
            echo "    --git-host <HOST>"
            echo "    --server"
            echo "    --generation"
            echo "    --pregeneration"
            echo "    --proxy http://proxy.chez.vous:port"
            exit 0
            ;;

        --os)
            os=$2
            shift 2
            ;;

        --git-host)
            git_host=$2
            shift 2
            ;;

        --tag)
            tag=$2
            shift 2
            ;;

        --server)
            server="1"
            shift 1
            ;;

        --generation)
            generation="1"
            shift 1
            ;;

        --pregeneration)
            pregeneration="1"
            shift 1
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

if [[ -z $tag ]]; then
    echo "No provided tag"
    exit 1
fi

build_params="$build_params --build-arg TAG=$tag --build-arg GIT_HOST=$git_host"

script_dir=$(dirname "$0")

###### SERVER
if [[ "$server" == "1" ]]; then
    cd server/ && docker build -t rok4/server:${tag}-${os} -f ${os}.Dockerfile $build_params .
fi

###### GENERATION
if [[ "$generation" == "1" ]]; then
    cd generation/ && docker build -t rok4/generation:${tag}-${os} -f ${os}.Dockerfile $build_params .
fi

###### PREGENERATION
if [[ "$pregeneration" == "1" ]]; then
    cd pregeneration/ && docker build -t rok4/pregeneration:${tag}-${os} -f ${os}.Dockerfile $build_params .
fi