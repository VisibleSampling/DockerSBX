KNOWLEDGE_DIR=".claude/knowledge"
[ -d "$KNOWLEDGE_DIR" ] || exit 0
CONTEXT=""
for f in "$KNOWLEDGE_DIR"/*.md "$KNOWLEDGE_DIR"/*.txt; do
    [ -f "$f" ] || continue
    CONTEXT+="--- $(basename "$f") ---
$(cat "$f")
"
done
[ -z "$CONTEXT" ] && exit 0
jq -n --arg ctx "Project knowledge base:
$CONTEXT" '{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": $ctx
  }
}'
exit 0
