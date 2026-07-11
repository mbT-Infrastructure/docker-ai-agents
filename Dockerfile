FROM madebytimo/development

ENV USER_GROUPS="user"

ADD --chmod=+x https://hermes-agent.nousresearch.com/install.sh /usr/local/bin/hermes-install.sh
RUN apt update -qq && apt install -y -qq ripgrep \
    && rm -rf /var/lib/apt/lists/* \
    && pip3-latest install open-terminal \
    && hermes-install.sh --skip-setup

COPY files/healthcheck-open-terminal.sh files/run-hermes.sh files/run-open-terminal.sh \
    /usr/local/bin/

ENV AI_API_URL=""
ENV AI_API_KEY=""
ENV AI_CONTEXT_LENGTH=512000
ENV AI_MODEL=default
ENV BASE_PATH="/"
ENV BRAVE_API_KEY=""
ENV OPEN_TERMINAL_API_KEY=""
ENV SIGNAL_ACCOUNT=""
ENV SIGNAL_ALLOWED_USERS=""
ENV SIGNAL_GROUP_ALLOWED_USERS=""
ENV SIGNAL_HOME_CHANNEL=""
ENV SIGNAL_SERVER_URL="http://signal-cli:8080"

CMD ["run-parallel.sh", "run-hermes.sh", "run-open-terminal.sh", "run-sshd.sh"]

HEALTHCHECK CMD [ "bash", "-c", "healthcheck-open-terminal.sh && healthcheck-sshd.sh" ]

LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/mbt-Infrastructure/docker-ai-agents"
