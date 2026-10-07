FROM docker.io/madebytimo/development-desktop

ENV USER_GROUPS="user"

RUN apt update -qq && apt install -y -qq ripgrep \
    && rm -rf /var/lib/apt/lists/* \
    && npm install --global opencode-ai \
    && pip3-latest install browser-use open-terminal \
    && mkdir --parents /usr/local/share/bash-completion/completions/ \
    && opencode completion > /usr/local/share/bash-completion/completions/opencode
ADD --chmod=a+rx https://hermes-agent.nousresearch.com/install.sh /usr/local/bin/hermes-install.sh

COPY files/opencode-config.json /usr/local/share/opencode-config.json
COPY files/hermes.desktop /usr/local/share/applications/
COPY files/entrypoint-ai-agents.sh files/healthcheck-open-terminal.sh \
    files/run-hermes.sh files/run-open-terminal.sh files/run-opencode.sh \
    /usr/local/bin/

ENV AI_API_URL=""
ENV AI_API_KEY=""
ENV AI_CONTEXT_LENGTH=512000
ENV AI_MODEL=default
ENV AI_VISION_MODEL=""
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
