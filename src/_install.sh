#!/bin/bash

set -euo pipefail

if [[ ${GIT_NAME:-} ]]; then
  git config --global --unset-all user.name || true
  git config --global --add user.name "$GIT_NAME"
fi

if [[ ${GIT_EMAIL:-} ]]; then
  git config --global --unset-all user.email || true
  git config --global --add user.email "$GIT_EMAIL"
fi
