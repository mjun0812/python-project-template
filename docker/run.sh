#!/usr/bin/env bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

IMAGE_NAME="$(basename -- "$PWD" | tr '[:upper:]' '[:lower:]')"
USER_ID="$(id -u)"
GROUP_ID="$(id -g)"
GROUP_NAME="$(id -gn)"
USER_NAME="${USER:-}"

DOCKER_OPTIONS=()
if docker system info | grep -E '^[[:space:]]*Runtimes: .*nvidia.*' >/dev/null; then
	# Use GPU
	DOCKER_OPTIONS+=(--gpus all)
fi

# Check if TTY is available (not in CI environment)
if [ -t 0 ] && [ -t 1 ]; then
	DOCKER_OPTIONS+=(-it)
fi

DOCKER_OPTIONS+=(
	--rm
	--shm-size=32g
	--net
	host
	--env
	"DISPLAY=${DISPLAY:-}"
	--env
	"USER_NAME=${USER_NAME}"
	--env
	"USER_ID=${USER_ID}"
	--env
	"GROUP_NAME=${GROUP_NAME}"
	--env
	"GROUP_ID=${GROUP_ID}"
	--workdir
	/app
	-v
	"${HOME:-}/.Xauthority:/home/${USER_NAME}/.Xauthority:rw"
	-v
	/tmp/.X11-unix:/tmp/.X11-unix:rw
	-v
	"${PWD}:/app"
	--name
	"${IMAGE_NAME}-$(date '+%s')"
)

COMMAND=("$@")
if (($# == 0)); then
	COMMAND=(bash)
fi

exec docker run \
	"${DOCKER_OPTIONS[@]}" \
	"${IMAGE_NAME}:latest" \
	"${COMMAND[@]}"
