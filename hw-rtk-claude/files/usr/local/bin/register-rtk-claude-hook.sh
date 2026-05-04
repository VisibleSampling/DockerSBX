#!/usr/bin/env bash
set -euo pipefail

mkdir -p /etc/claude-code
settings=/etc/claude-code/managed-settings.json
tmp=$(mktemp)

if [ ! -s "$settings" ]; then
  printf '{"hooks":{"PreToolUse":[]}}\n' > "$settings"
fi

jq '
  .hooks = (.hooks // {}) |
  .hooks.PreToolUse = (.hooks.PreToolUse // []) |
  if any(.hooks.PreToolUse[]?; .hooks[]? .command == "/usr/local/bin/rtk-rewrite-claude.sh") then
    .
  else
    .hooks.PreToolUse += [{
      "matcher": "Bash",
      "hooks": [{ "type": "command", "command": "/usr/local/bin/rtk-rewrite-claude.sh" }]
    }]
  end
' "$settings" > "$tmp"

cat "$tmp" > "$settings"
rm -f "$tmp"
chmod 0644 "$settings"
