#!/usr/bin/env bash
set -eu

# Refactor some variable
export SERVICE_KEYWORDS_JSON=$(echo $SERVICE_KEYWORDS | sed "s#,#\",\"#g")

# Setup server.json : if final file already exists, we don't overwrite it
if [[ ! -f /configurations/server.json ]]; then
    envsubst < /etc/rok4/server.template.json > /configurations/server.json
else
    echo "/configurations/server.json exists: we don't overwrite it"
fi

# Setup services.json : if final file already exists, we don't overwrite it
if [[ ! -f /configurations/services.json ]]; then
    envsubst < /etc/rok4/services.template.json > /configurations/services.json
else
    echo "/configurations/services.json exists: we don't overwrite it"
fi

exec "$@"