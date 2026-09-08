# Development Guidelines

This document contains critical information about working with this codebase.
Follow these guidelines precisely.

## Rules

1. Package Management
   - ONLY use uv, NEVER pip
   - Installation: `uv add package`
   - Upgrading: `uv add --dev package --upgrade-package package`
   - FORBIDDEN: `uv pip install`, `@latest` syntax, editing `uv.lock` by hand

2. Code Quality
   - Type hints required for all code
   - Imports used only in type annotations go under `if TYPE_CHECKING:` with
     `from __future__ import annotations` at the top of the module (Ruff `TC` rules)
   - Follow existing patterns exactly
   - Use Google style for docstring

3. Testing Requirements
   - Framework: `uv run --frozen pytest` (runs in parallel; use `-n 0` for `--pdb`)
   - Coverage: test edge cases and errors
   - Coverage report: `uv run --frozen pytest --cov` (CI fails below 80% branch coverage of `src/`)
   - New features require tests
   - Bug fixes require regression tests

4. Git
   - Follow the Conventional Commits style on commit messages.
   - NEVER use `git commit --no-verify`; fix what the hooks report instead.

5. Running
   - Application: `uv run Python-Project-Template` (or `python -m my_package`)

## Code Formatting and Linting

1. Ruff
   - Format: `uv run --frozen ruff format .`
   - Check: `uv run --frozen ruff check .`
   - Fix: `uv run --frozen ruff check . --fix`
2. Type Check
   - Check: `uv run --frozen ty check`
3. Git Hooks (prek)
   - Config: `.pre-commit-config.yaml`
   - Install: `uv run prek install`
   - Runs: on git commit
   - Tools: uv lock, Ruff, ty
4. Agent Hooks
   - `.agents/hooks/format-python.sh` formats and lints every Python file right
     after Claude Code or Codex edits it (wired in `.claude/settings.json` and
     `.codex/hooks.json`). Do not re-run the formatter manually after edits.
