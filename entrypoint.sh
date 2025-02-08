#!/bin/bash

# Exit on any error
set -e

CONFIGURED_RUNNER=false

# If $GITHUB_RUNNER_TOKEN is set, we configure the runner
if [[ -n "${GITHUB_RUNNER_TOKEN}" ]]; then
  echo "Configuring GitHub Actions Runner..."

  ./config.sh --unattended \
    --url "${GITHUB_RUNNER_URL}" \
    --token "${GITHUB_RUNNER_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --labels" ${RUNNER_LABELS}" \
    --replace

  CONFIGURED_RUNNER=true
else
  echo "No registration token found. Make sure to set GITHUB_RUNNER_TOKEN."
fi

# Run the runner service
if [ "$CONFIGURED_RUNNER" = true ]; then
  echo "Starting runner..."
  trap 'echo "Removing runner..."; ./config.sh remove --unattended --token ${GITHUB_RUNNER_TOKEN}; exit 0' SIGINT SIGQUIT SIGTERM

  ./run.sh &
  wait $!
else
  echo "Runner is not configured. Exiting."
  exit 1
fi
