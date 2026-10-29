#!/usr/bin/env bash
set -e -o pipefail

COMMAND_RUNNER=(su user --login --command)
if [[ "$EUID" -ne 0 ]]; then
    COMMAND_RUNNER=(bash -c)
fi


exec "${COMMAND_RUNNER[@]}" "mkdir --parents ~/.config/opencode/ \
    && ln --force --symbolic --target-directory ~/.config/opencode/ \
        /opt/ai-agent-library/{agents,skills} \
    && ln --force --symbolic --no-target-directory /opt/ai-agent-library/prompts \
        ~/.config/opencode/commands \
    && replace-vars.sh /opt/ai-agent-library/AGENTS.md > ~/.config/opencode/AGENTS.md \
    && opencode service set disabled true \
    && OPENCODE_PASSWORD='$USER_PASSWORD' opencode serve --hostname 0.0.0.0 --port 11003"
