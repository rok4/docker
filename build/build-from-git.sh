#!/bin/bash

set -e

component=""
os="debian11"
tag=""
git_host="https://github.com"
build_params=""

ARGUMENTS="os:,component:,proxy:,help,tag:,git-host:"
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
            echo "./build-from-git.sh <OPTIONS>"
            echo "    --os debian11"
            echo "    --tag <TAG>"
            echo "    --git-host <HOST>"
            echo "    --component server|generation|pregeneration|tools"
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


if [[ -z $tag ]]; then
    echo "No provided tag"
    exit 1
fi

build_params="$build_params --build-arg TAG=$tag --build-arg GIT_HOST=$git_host --build-arg CACHEBUST=\"$(date +%s)\""

###### SERVER
if [[ "$component" == "server" ]]; then
    cd server/ && docker build -t rok4/server:${tag}-${os} -f ${os}-from-git.Dockerfile $build_params .
fi

###### GENERATION
if [[ "$component" == "generation" ]]; then
    cd generation/ && docker build -t rok4/generation:${tag}-${os} -f ${os}-from-git.Dockerfile $build_params .
fi

###### PREGENERATION
if [[ "$component" == "pregeneration" ]]; then
    cd pregeneration/ && docker build -t rok4/pregeneration:${tag}-${os} -f ${os}-from-git.Dockerfile $build_params .
fi

###### TOOLS
if [[ "$component" == "tools" ]]; then
    cd tools/ && docker build -t rok4/tools:${tag}-${os} -f ${os}-from-git.Dockerfile $build_params .
fi