#!/usr/bin/env bash
# Guards paths that shouldn't be rewritten casually.
#
# Decision records are history: they get superseded, not edited. This escalates
# to you rather than hard-blocking, since legitimate edits exist (marking one
# superseded, fixing a typo).
#
# To hard-block a path instead, add it to DENY below. "deny" cannot be
# overridden by Claude; "ask" prompts you.
set -euo pipefail

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""')
[ -n "$FILE" ] || exit 0

# Hard-blocked paths. Empty by default — add patterns as you find you need them.
DENY=''

# Escalate to the user. Existing decision records only; new ones pass through.
ASK='docs/decisions/DR-[0-9]+.*\.md$'

if [ -n "$DENY" ] && printf '%s' "$FILE" | grep -Eq "$DENY"; then
  jq -n --arg f "$FILE" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: ("Protected path: " + $f)
    }
  }'
  exit 0
fi

if printf '%s' "$FILE" | grep -Eq "$ASK" && [ -f "$FILE" ]; then
  jq -n --arg f "$FILE" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: ("Editing an existing decision record (" + $f +
        "). Decisions are normally superseded by a new record rather than rewritten. Confirm this is a status update or correction.")
    }
  }'
  exit 0
fi

exit 0
