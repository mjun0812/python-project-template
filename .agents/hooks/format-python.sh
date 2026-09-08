#!/usr/bin/env bash
# PostToolUse hook shared by Claude Code and Codex: format and lint the Python
# files the agent just edited. Reads the hook input JSON from stdin.
#
# Claude Code (Edit/Write) reports the file in tool_input.file_path.
# Codex (apply_patch) reports the whole patch in tool_input.command.
# Remaining lint errors are sent back to the agent via exit code 2.

set -euo pipefail

input="$(cat)"

files=()
while IFS= read -r file; do
	[[ "${file}" == *.py ]] && files+=("${file}")
done < <(jq -r '
	(.tool_input.file_path // empty),
	((.tool_input.command // "") | scan("\\*\\*\\* (?:Add|Update) File: (.+)") | .[0])
' <<<"${input}")

# Avoid the array-length expansion here: its brace-hash prefix would start a Jinja
# comment when Copier renders this file.
[[ -n "${files[*]:-}" ]] || exit 0

cwd="$(jq -r '.cwd // empty' <<<"${input}")"
cd -- "${cwd:-$(git rev-parse --show-toplevel)}"

uv run --frozen ruff format -- "${files[@]}"
if ! uv run --frozen ruff check --fix -- "${files[@]}" >&2; then
	exit 2
fi
