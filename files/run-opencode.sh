#!/usr/bin/env bash
set -e -o pipefail

su user --login --command "mkdir --parents ~/.config/opencode/ \
    && ln --force --symbolic --target-directory ~/.config/opencode/ \
        /opt/ai-agent-library/{agents,skills} \
    && ln --force --symbolic --no-target-directory /opt/ai-agent-library/prompts \
        ~/.config/opencode/commands \
    && replace-vars.sh /opt/ai-agent-library/AGENTS.md > ~/.config/opencode/AGENTS.md \
    && OPENCODE_PASSWORD='$USER_PASSWORD' opencode serve --hostname 0.0.0.0 --port 11003"
