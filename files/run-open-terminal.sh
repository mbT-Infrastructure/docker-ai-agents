#!/usr/bin/env bash
set -e -o pipefail

COMMAND_RUNNER=(su user --login --command)
if [[ "$EUID" -ne 0 ]]; then
    COMMAND_RUNNER=(bash -c)
fi


exec "${COMMAND_RUNNER[@]}" \
    "open-terminal run --host 0.0.0.0 --port 11004 --api-key '$OPEN_TERMINAL_API_KEY'"
