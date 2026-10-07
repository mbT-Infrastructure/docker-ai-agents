#!/usr/bin/env bash
set -e -o pipefail

cd /media/user

SIGNAL_HTTP_URL="$SIGNAL_SERVER_URL"
if [[ -z "$SIGNAL_HOME_CHANNEL" ]]; then
    SIGNAL_HOME_CHANNEL="${SIGNAL_ALLOWED_USERS%%,*}"
fi

export SIGNAL_HOME_CHANNEL SIGNAL_HTTP_URL

su user --login --whitelist-environment \
    SIGNAL_ACCOUNT,SIGNAL_ALLOWED_USERS,SIGNAL_GROUP_ALLOWED_USERS,SIGNAL_HOME_CHANNEL,SIGNAL_HTTP_URL \
    --command \
    "hermes-install.sh --include-desktop --non-interactive \
    && mkdir --parents ~/.local/share/bash-completion/completions/ \
    && hermes completion bash > ~/.local/share/bash-completion/completions/hermes \
    \
    && hermes config set dashboard.basic_auth.password '$USER_PASSWORD' \
    && hermes config set dashboard.basic_auth.username user \
    \
    && hermes config set model.default '$AI_MODEL' \
    && hermes config set model.provider container-config \
    && hermes config set model.context_length '$AI_CONTEXT_LENGTH' \
    && hermes config set auxiliary.title_generation.model '$AI_CHEAP_MODEL' \
    && hermes config set auxiliary.title_generation.provider container-config \
    && hermes config set auxiliary.title_generation.timeout '$AI_REQUEST_TIMEOUT' \
    && hermes config set auxiliary.vision.model '$AI_VISION_MODEL' \
    && hermes config set auxiliary.vision.provider container-config \
    && hermes config set auxiliary.vision.timeout '$AI_REQUEST_TIMEOUT' \
    && hermes config set providers.container-config.base_url '$AI_API_URL' \
    && hermes config set providers.container-config.api_key '$AI_API_KEY' \
    && hermes config set providers.container-config.default_model '$AI_MODEL' \
    && hermes config set providers.container-config.request_timeout_seconds '$AI_REQUEST_TIMEOUT' \
    && hermes config set providers.container-config.stale_timeout_seconds '$AI_REQUEST_TIMEOUT' \
    \
    && hermes config set providers.container-config.models.default.context_length 200000 \
    && hermes config set providers.container-config.models.fast.context_length 200000 \
    \
    && hermes config set desktop.electron_flags '[--no-sandbox, --disable-dev-shm-usage]' \
    && hermes config set display.bell_on_complete true \
    && hermes config set display.bell_on_prompt true \
    && hermes config set model_catalog.excluded_providers '[actual,ai-gateway,alibaba,alibaba-cn,\
        alibaba-coding-plan,alibaba-coding-plan-cn,alibaba-token-plan,alibaba-token-plan-cn,\
        anthropic,arcee,azure-foundry,bedrock,commandcode,commandcode-anthropic,copilot,\
        copilot-acp,custom,deepinfra,deepseek,fireworks,gemini,gmi,huggingface,kilocode,\
        kimi-coding,kimi-coding-cn,lmstudio,meta-ai,minimax,minimax-cn,minimax-oauth,moa,\
        nebius-token-factory,nous,novita,nvidia,ollama-cloud,openai-api,openai-codex,\
        opencode-free,opencode-go,opencode-zen,openrouter,qwen-oauth,router,stepfun,\
        tencent-tokenhub,tencent-tokenplan,upstage,vertex,xai,xai-oauth,xiaomi,zai]' \
    && hermes config set privacy.redact_pii false \
    && hermes config set telemetry.shared_metrics.enabled false \
    && hermes config set telemetry.shared_metrics.send false"

cat > /media/user/.hermes/.env <<EOF
BRAVE_SEARCH_API_KEY=$BRAVE_API_KEY
HERMES_STREAM_READ_TIMEOUT=$AI_REQUEST_TIMEOUT
HERMES_STREAM_STALE_TIMEOUT=$AI_REQUEST_TIMEOUT
EOF

chown user:user /media/user/.hermes/.env
chmod 600 /media/user/.hermes/.env

PIDS=()
su user --login --command "hermes gateway run" &
PIDS+=("$!")
su user --login --command "hermes dashboard --host 0.0.0.0 --port 11002 --skip-build" &
PIDS+=("$!")

wait -n "${PIDS[@]}"
