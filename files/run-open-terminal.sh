#!/usr/bin/env bash
set -e -o pipefail

su user --command "open-terminal run --host 0.0.0.0 --port 11004 --api-key '$OPEN_TERMINAL_API_KEY'"
