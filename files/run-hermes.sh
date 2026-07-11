#!/usr/bin/env bash
set -e -o pipefail

cd /media/user

SIGNAL_HTTP_URL="$SIGNAL_SERVER_URL"

if [[ -z "$SIGNAL_HOME_CHANNEL" ]]; then
    SIGNAL_HOME_CHANNEL="${SIGNAL_ALLOWED_USERS%%,*}"
fi

export SIGNAL_HOME_CHANNEL SIGNAL_HTTP_URL

su user --whitelist-environment \
    BRAVE_API_KEY,SIGNAL_ACCOUNT,SIGNAL_ALLOWED_USERS,SIGNAL_GROUP_ALLOWED_USERS,SIGNAL_HOME_CHANNEL,SIGNAL_HTTP_URL \
    --command \
    "hermes config set model.provider container-config \
    && hermes config set providers.container-config.base_url '$AI_API_URL' \
    && hermes config set providers.container-config.api_key '$AI_API_KEY' \
    && hermes config set providers.container-config.default_model '$AI_MODEL' \
    && hermes config set providers.container-config.context_length '$AI_CONTEXT_LENGTH' \
    && hermes config set web.search_backend  brave-free \
    && hermes gateway run" \
