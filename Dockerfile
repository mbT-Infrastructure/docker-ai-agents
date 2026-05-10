FROM madebytimo/development

ENV USER_GROUPS="user"

RUN npm install --global openclaw@latest \
    && usermod --groups "$USER_GROUPS" user \
    && mkdir /media/openclaw \
    && chown user:user /media/openclaw

WORKDIR /opt/openclaw
COPY files/entrypoint-openclaw.sh files/healthcheck-openclaw.sh files/run-openclaw.sh /usr/local/bin/
COPY files/openclaw.json  /opt/openclaw

ENV AI_API_URL=""
ENV AI_API_KEY=""
ENV AI_MODEL=default
ENV ALLOWED_ORIGIN="http://127.0.0.1:18789"
ENV BRAVE_API_KEY=""
ENV OPENCLAW_HOME="/media/openclaw"
ENV OPENCLAW_CONFIG_PATH="/opt/openclaw/openclaw.json"
ENV OPENCLAW_STATE_DIR="/media/openclaw/.openclaw"
ENV PASSWORD=""
ENV SIGNAL_ACCOUNT=""
ENV SIGNAL_ALLOW_FROM=""
ENV SIGNAL_SERVER_URL="http://signal-cli:8080"

USER user
WORKDIR /media/user
ENTRYPOINT [ "entrypoint-openclaw.sh" ]
CMD [ "run-openclaw.sh" ]

HEALTHCHECK CMD [ "healthcheck-openclaw.sh" ]

LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/mbt-Infrastructure/docker-openclaw-sandbox"
