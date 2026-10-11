FROM --platform=$BUILDPLATFORM docker.io/madebytimo/scripts AS builder

WORKDIR /root/builder/

ADD https://api.github.com/repos/mbT-Infrastructure/ai-agent-library/releases/latest \
    ai-agent-library-release.json
RUN VERSION="$(download.sh --output - \
        https://api.github.com/repos/mbT-Infrastructure/ai-agent-library/releases/latest \
        | sed --silent 's|^\s*"tag_name": "\(.*\)".*$|\1|p' \
        | head --lines 1)" \
    && ls -la && echo "Version: $VERSION" \
    && download.sh --name ai-agent-library.tar.zst \
    "https://github.com/mbT-Infrastructure/ai-agent-library/releases/download/${VERSION}/ai-agent-library-${VERSION}.tar.zst" \
    && compress.sh --decompress ai-agent-library.tar.zst \
    && rm ai-agent-library.tar.zst ai-agent-library-release.json

FROM docker.io/madebytimo/development-desktop

ENV USER_GROUPS="user"
ENV PIP_ROOT_USER_ACTION="ignore"

RUN apt update -qq && apt install -y -qq jq ripgrep \
    && rm -rf /var/lib/apt/lists/* \
    && npm install --global @opencode/cli \
    && pip3-latest install browser-use open-terminal \
    && mkdir --parents /usr/local/share/bash-completion/completions/ \
    && opencode --completions bash > /usr/local/share/bash-completion/completions/opencode
ADD --chmod=a+rx https://hermes-agent.nousresearch.com/install.sh /usr/local/bin/hermes-install.sh

COPY files/opencode-config.json /usr/local/share/opencode-config.json
COPY files/hermes.desktop /usr/local/share/applications/
COPY --from=builder /root/builder/ai-agent-library /opt/ai-agent-library
COPY files/entrypoint-ai-agents.sh files/healthcheck-open-terminal.sh \
    files/run-hermes.sh files/run-open-terminal.sh files/run-opencode.sh \
    /usr/local/bin/

ENV AI_API_URL=""
ENV AI_API_KEY=""
ENV AI_CONTEXT_LENGTH=512000
ENV AI_MODEL=default
ENV AI_CHEAP_MODEL=""
ENV AI_DECIDER_MODEL="decider"
ENV AI_VISION_MODEL=""
ENV AI_NAME="AI-Assistant"
ENV AI_REQUEST_TIMEOUT=1800
ENV BASE_PATH="/"
ENV BRAVE_API_KEY=""
ENV OPENCODE_CONFIG=/usr/local/share/opencode-config.json
ENV OPEN_TERMINAL_API_KEY=""
ENV SIGNAL_ACCOUNT=""
ENV SIGNAL_ALLOWED_USERS=""
ENV SIGNAL_GROUP_ALLOWED_USERS=""
ENV SIGNAL_HOME_CHANNEL=""
ENV SIGNAL_SERVER_URL="http://signal-cli:8080"

ENTRYPOINT [ "entrypoint-ai-agents.sh" ]
CMD ["run-parallel.sh", "run-hermes.sh", "run-open-terminal.sh", "run-opencode.sh", \
    "run-docker.sh", "run-sshd.sh", "run-desktop.sh" ]

HEALTHCHECK CMD [ "bash", "-c", "healthcheck-open-terminal.sh && healthcheck-sshd.sh" ]

LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/mbt-Infrastructure/docker-ai-agents"
