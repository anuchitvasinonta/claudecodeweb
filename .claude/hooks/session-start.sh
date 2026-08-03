#!/usr/bin/env bash
# Injects current project state into context at session start, so it doesn't
# depend on Claude choosing to read the file.
set -euo pipefail

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
command -v jq >/dev/null 2>&1 || exit 0

STATE=$(cat PROJECT_STATE.md 2>/dev/null || echo "(no PROJECT_STATE.md yet)")
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)
RECENT=$(git log --oneline -5 2>/dev/null || echo "(no commits yet)")

jq -n --arg s "$STATE" --arg b "$BRANCH" --arg r "$RECENT" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: (
      "## Current project state\n\n" + $s +
      "\n\n## Git\n\nBranch: " + $b + "\n\nRecent commits:\n" + $r
    )
  }
}'
