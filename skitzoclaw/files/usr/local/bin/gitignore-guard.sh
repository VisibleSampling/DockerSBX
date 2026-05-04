#!/bin/bash
INPUT=$(cat)

is_exempt() {
  case "$1" in
    */.claude/*|.claude/*|*/.mcp.json|.mcp.json) return 0 ;;
  esac
  return 1
}

is_ignored() {
  git check-ignore -q "$1" 2>/dev/null
}

# Read/Edit/Write: check file_path directly
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
if [ -n "$FILE_PATH" ]; then
  is_exempt "$FILE_PATH" && exit 0
  is_ignored "$FILE_PATH" && {
    echo "Access denied: $FILE_PATH is listed in .gitignore"
    exit 2
  }
  exit 0
fi

# Bash: scan command tokens for gitignored paths
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
if [ -n "$COMMAND" ]; then
  for token in $COMMAND; do
    [[ "$token" == -* ]] && continue
    [[ ${#token} -lt 2 ]] && continue
    is_exempt "$token" && continue
    is_ignored "$token" && {
      echo "Access denied: command references gitignored file: $token"
      exit 2
    }
  done
fi

exit 0
