# syntax=docker/dockerfile:1

FROM ghcr.io/astral-sh/uv:0.12.10 AS uv

FROM mcr.microsoft.com/devcontainers/base:resolute

COPY --from=uv /uv /uvx /usr/local/bin/

RUN rm -f /etc/apt/apt.conf.d/docker-clean \
    && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        fd-find \
        git \
        jq \
        ripgrep \
        wget \
    && curl -fsSL https://github.com/openai/codex/releases/latest/download/install.sh -o /tmp/install-codex.sh \
    && CODEX_INSTALL_DIR=/usr/local/bin \
        CODEX_HOME=/opt/codex \
        CODEX_NON_INTERACTIVE=1 \
        sh /tmp/install-codex.sh \
    && rm -f /tmp/install-codex.sh

# Claude Code's native installer installs under $HOME, so run it as the container user
USER vscode
RUN curl -fsSL https://claude.ai/install.sh | bash \
    && rm -rf /home/vscode/.claude/downloads
USER root
RUN ln -s /home/vscode/.local/bin/claude /usr/local/bin/claude
