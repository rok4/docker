#!/usr/bin/env bash
set -eu

# Refactor some variable
export SERVICE_KEYWORDS_JSON=$(echo $SERVICE_KEYWORDS | sed "s#,#\",\"#g")
export SERVICE_FORMATLIST_JSON=$(echo $SERVICE_FORMATLIST | sed "s#,#\",\"#g")
export SERVICE_GLOBALCRSLIST_JSON=$(echo $SERVICE_GLOBALCRSLIST | sed "s#,#\",\"#g")

# Setup server.json
envsubst < /etc/rok4/server.template.json > /etc/rok4/server.json

# Setup services.json
envsubst < /etc/rok4/services.template.json > /etc/rok4/services.json

# Centralisation des descripteurs de couches
if [[ ! -z $IMPORT_LAYERS_FROM_PYRAMIDS ]] ; then
    for lay in $(find /pyramids/ -maxdepth 2 -name "*.lay.json"); do
        bn=$(basename -s ".lay.json" $lay)
        cp $lay /etc/rok4/layers/$bn.json
    done
fi

exec "$@"