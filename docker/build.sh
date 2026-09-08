#!/usr/bin/env bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

BUILDER_IMAGE="ubuntu:26.04"
RUNNER_IMAGE="ubuntu:26.04"
IMAGE_NAME="$(basename -- "$PWD" | tr '[:upper:]' '[:lower:]')"

exec docker build \
	--build-arg "BUILDER_IMAGE=${BUILDER_IMAGE}" \
	--build-arg "RUNNER_IMAGE=${RUNNER_IMAGE}" \
	-t "${IMAGE_NAME}:latest" \
	-f docker/Dockerfile .
