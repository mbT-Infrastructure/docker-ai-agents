#!/usr/bin/env bash
set -e -o pipefail

curl --fail --location http://localhost:8000/health || exit 1
