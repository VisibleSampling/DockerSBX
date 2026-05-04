#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)

is_exempt() {
  case "$1" in
    */.codex/*|.codex/*|*/.mcp.json|.mcp.json) return 0 ;;
  esac
  return 1
}

is_ignored() {
  git check-ignore -q -- "$1" 2>/dev/null
}

deny() {
  local reason="$1"
  jq -n --arg reason "$reason" '{
    "hookSpecificOutput": {
      "hookEventName": "PreToolUse",
      "permissionDecision": "deny",
      "permissionDecisionReason": $reason
    }
  }'
  exit 0
}

deny_if_ignored() {
  local path="$1"
  [ -n "$path" ] || return 0
  is_exempt "$path" && return 0
  if is_ignored "$path"; then
    deny "Access denied: $path is listed in .gitignore"
  fi
}

# File-oriented tools commonly pass one of these path fields.
jq -r '
  [
    .tool_input.file_path?,
    .tool_input.path?,
    .tool_input.cwd?
  ] | .[]? | select(type == "string" and length > 0)
' <<<"$INPUT" | while IFS= read -r path; do
  deny_if_ignored "$path"
done

# apply_patch content includes file paths in patch headers.
jq -r '.tool_input.command // .tool_input.patch // empty' <<<"$INPUT" \
  | sed -nE 's/^\*\*\* (Add|Update|Delete) File: (.*)$/\2/p' \
  | while IFS= read -r path; do
      deny_if_ignored "$path"
    done

# Bash: scan command tokens for gitignored paths. This is a deterrent,
# not a shell parser.
COMMAND=$(jq -r '.tool_input.command // empty' <<<"$INPUT")
if [ -n "$COMMAND" ]; then
  for token in $COMMAND; do
    token="${token#\"}"
    token="${token%\"}"
    token="${token#\'}"
    token="${token%\'}"
    [[ "$token" == -* ]] && continue
    [[ ${#token} -lt 2 ]] && continue
    deny_if_ignored "$token"
  done
fi

exit 0
