#!/usr/bin/env bash
# Source this shared loader. Config values are parsed as literals and quoted by
# Python; caller-provided environment overrides still take precedence.
KV260_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kv260_exports="$(/usr/bin/python3 "${KV260_SCRIPT_DIR}/launcher_core.py" --shell-env)" || return 1
eval "${kv260_exports}"
unset kv260_exports