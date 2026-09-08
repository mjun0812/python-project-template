# syntax=docker/dockerfile:1

ARG BUILDER_IMAGE="ubuntu:26.04"
ARG RUNNER_IMAGE="ubuntu:26.04"

FROM ghcr.io/astral-sh/uv:0.12.10 AS uv

FROM $BUILDER_IMAGE AS builder

ENV DEBIAN_FRONTEND=noninteractive \
    UV_PYTHON_INSTALL_DIR="/opt/python" \
    UV_PROJECT_ENVIRONMENT="/opt/venv" \
    # Compile packages to bytecode after installation
    UV_COMPILE_BYTECODE=1 \
    # Copy packages from wheel
    UV_LINK_MODE=copy

RUN rm -f /etc/apt/apt.conf.d/docker-clean \
    && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
--mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates

COPY --from=uv /uv /bin/uv
WORKDIR /app

# Sync dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=.python-version,target=.python-version \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    ulimit -n 8192 \
    && uv sync --locked --no-install-project --no-editable

# Sync this project
COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
    ulimit -n 8192 \
    && uv sync --locked --no-editable

FROM $RUNNER_IMAGE AS production

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/opt/venv/bin:$PATH" \
    UV_PYTHON_INSTALL_DIR="/opt/python" \
    UV_PROJECT_ENVIRONMENT="/opt/venv" \
    # Disable buffering of standard output and error streams
    PYTHONUNBUFFERED=1 \
    # Disable generation of .pyc files
    PYTHONDONTWRITEBYTECODE=1

# Copy Python
COPY --from=builder /opt/python /opt/python
COPY --from=builder /opt/venv /opt/venv
COPY --from=uv /uv /bin/uv

RUN rm -f /etc/apt/apt.conf.d/docker-clean \
    && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    build-essential \
    sudo \
    gosu

# Allow sudo without password
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY --chmod=755 ./docker/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
