# Python-Project-Template

[![CI](https://github.com/mjun0812/python-project-template/actions/workflows/ci.yml/badge.svg)](https://github.com/mjun0812/python-project-template/actions/workflows/ci.yml)

A simple modern Python project template.

This repository is created by [mjun0812/python-copier-template](https://github.com/mjun0812/python-copier-template) using [copier](https://copier.readthedocs.io/).

[Article](https://mjunya.com/en/posts/2025-06-15-python-template/) [日本語記事](https://zenn.dev/mjun0812/articles/0ae2325d40ed20)

## Features

- 🚀 **Modern Python**: Support for Python 3.10-3.13
- 📦 **uv Package Manager**: Fast and reliable package management with [uv](https://github.com/astral-sh/uv)
- 🐳 **Docker Support**: Complete Docker development environment
- 📦 **Devcontainer Support**: VS Code devcontainer for consistent development
- ✨ **AI Editor Support**: [Cursor rules](https://docs.cursor.com/context/rules) and
  [CLAUDE.md](https://docs.anthropic.com/en/docs/claude-code/overview) included for AI-powered development
- 📝 **Type Hints**: Full type annotation support with modern Python features
- 🔍 **Code Quality**: Pre-configured Ruff for linting and formatting
- 🧪 **Testing**: pytest setup with example tests
- 🔧 **Pre-commit Hooks**: Automated code quality checks
- 🏗️ **CI Ready**: GitHub Actions workflows included

## Quick Start

### Pre-Requirements

- [uv](https://docs.astral.sh/uv/): Fast Python package installer

### Development Setup

```bash
# Install dependencies
uv sync --locked

# Install git hooks
uv run prek install

# Run the application
uv run Python-Project-Template

# Run tests
uv run pytest
# Run tests with coverage
uv run pytest --cov

# Run formatting and linting (automatically runs on commit)
uv run ruff format .
uv run ruff check .
# Auto Fix
uv run ruff check . --fix
```

<<<<<<< before updating
### Docker Development Setup
=======
### AI Coding Agents

Rules for agents live in `AGENTS.md` (`CLAUDE.md` imports it). A shared hook formats and lints every Python
file right after Claude Code or Codex edits it, and reports the remaining diagnostics back to the agent:

- `.agents/hooks/format-python.sh`: the hook script, runs `ruff format` and `ruff check --fix`
- `.claude/settings.json`: Claude Code permissions and the `PostToolUse` hook (committed; put personal
  overrides in `.claude/settings.local.json`, which is git-ignored)
- `.codex/hooks.json`: the same `PostToolUse` hook for Codex

Both tools require the project to be trusted before they apply its configuration:

- Claude Code: accept the trust prompt the first time you open the project.
- Codex: trust the project, then review and trust the hook with `/hooks`. Until you do, Codex skips the
  hook without reporting an error.

### Docker Development
>>>>>>> after updating

The template includes a complete Docker setup:

```bash
# use the provided scripts
./docker/build.sh
./docker/run.sh # or./docker/run.sh (Command)

# Build and run with Docker Compose
docker compose build
docker compose up
```

### VS Code Devcontainer

Open the project in VS Code and use the "Reopen in Container" command for a fully configured development environment.
<<<<<<< before updating

### Update Template

Thit template is created by [mjun0812/python-copier-template](https://github.com/mjun0812/python-copier-template).
You can apply update from it.

```bash
cd your-project-name
uvx copier update -A
```

## Project Structure

```text
your-project/
├── src/
│   └── your_project/          # Main package
├── tests/                     # Test files
├── docker/                    # Docker configuration
├── compose.yml               # Docker Compose setup
├── pyproject.toml            # Project configuration
└── README.md                 # Project documentation
```

## Q&A

### Why don't you use a type checker?

I'm waiting for stable release of [`ty`](https://github.com/astral-sh/ty).
You can install and use your preferred type checker.

## Support

- 📖 [Copier Documentation](https://copier.readthedocs.io/)
- 🐍 [uv Documentation](https://docs.astral.sh/uv/)
- 🔍 [Ruff Documentation](https://docs.astral.sh/ruff/)
=======
Devcontainer automatically installs uv, Claude Code, and Codex. The latest Claude Code and Codex releases are
installed with their official installers when the image is built, so rebuild the image to update them.

The container mounts the host `${HOME}/.claude` and `${HOME}/.codex` directories at `/home/vscode/.claude` and
`/home/vscode/.codex` for authentication. These bind mounts are read-write, so changes made in the container can
affect the host configuration. The uv cache is kept in a named volume and reused across container rebuilds.
>>>>>>> after updating
