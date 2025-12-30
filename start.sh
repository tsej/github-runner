#!/bin/bash

REPOSITORY=$REPO
ACCESS_TOKEN=$TOKEN
RUNNER_NAME=${RUNNER_PREFIX:-_}`hostname`
RUNNER_LABELS=${RUNNER_LABELS:-docker}

echo "REPO ${REPOSITORY}"
echo "ACCESS_TOKEN ${ACCESS_TOKEN}"
echo "RUNNER_NAME ${RUNNER_NAME}"
echo "RUNNER_LABELS ${RUNNER_LABELS}"

./config.sh \
    --url https://github.com/${REPOSITORY} \
    --token ${ACCESS_TOKEN} \
    --name ${RUNNER_NAME} \
    --labels ${RUNNER_LABELS}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token ${ACCESS_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!