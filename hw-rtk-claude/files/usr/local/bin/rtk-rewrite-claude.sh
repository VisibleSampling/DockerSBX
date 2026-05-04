#!/usr/bin/env bash
if ! command -v jq >/dev/null 2>&1; then
  echo "[rtk] WARNING: jq is not installed. Hook cannot rewrite commands." >&2
  exit 0
fi

if ! command -v rtk >/dev/null 2>&1; then
  echo "[rtk] WARNING: rtk is not installed or not in PATH. Hook cannot rewrite commands." >&2
  exit 0
fi

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
if [ -z "$CMD" ]; then
  exit 0
fi

case "$CMD" in
  rtk|rtk\ *) exit 0 ;;
esac

REWRITTEN=$(rtk rewrite "$CMD" 2>/dev/null || true)
if [ -z "$REWRITTEN" ]; then
  printf -v QUOTED_CMD '%q' "$CMD"
  REWRITTEN="rtk run $QUOTED_CMD"
elif [ "$CMD" = "$REWRITTEN" ]; then
  printf -v QUOTED_CMD '%q' "$CMD"
  REWRITTEN="rtk run $QUOTED_CMD"
fi

ORIGINAL_INPUT=$(echo "$INPUT" | jq -c '.tool_input')
UPDATED_INPUT=$(echo "$ORIGINAL_INPUT" | jq --arg cmd "$REWRITTEN" '.command = $cmd')
jq -n \
  --argjson updated "$UPDATED_INPUT" \
  '{ "hookSpecificOutput": { "hookEventName": "PreToolUse", "permissionDecision": "allow", "permissionDecisionReason": "RTK auto-rewrite", "updatedInput": $updated } }'
