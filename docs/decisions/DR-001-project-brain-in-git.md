# DR-001: Keep project knowledge in git rather than relying on chat history

- **Status:** Accepted
- **Date:** 2026-08-03

## Context

Every Claude Code session starts with a fresh context window, on every surface
— web, desktop, CLI. A new session knows nothing about previous sessions.
Individual sessions can be resumed with their history intact, but that only
helps if you continue the same conversation forever, which auto-compaction
eventually degrades into a summary anyway.

Claude Code's auto memory does persist across sessions, but it is machine-local
and explicitly not shared with cloud environments, so it is absent entirely in
web sessions. It also captures what Claude judged worth remembering, not what I
decided or why.

## Options considered

1. **Back up and restore chat history across machines** — rejected. Restored
   transcripts don't enter new sessions; you'd have to resume one specific
   conversation, which grows until it compacts into a lossy summary. Also
   requires syncing a private local directory and hoping the format holds.
2. **Rely on auto memory** — rejected as the primary mechanism. Capped at 200
   lines / 25KB for the loaded index, machine-local, and it records tooling
   quirks rather than decisions. Kept as a free bonus layer.
3. **Commit a structured project brain to git** — chosen.

## Decision

Project knowledge lives in version-controlled markdown: `CLAUDE.md` as the
entry point, one `PROJECT_STATE.md`, and numbered decision records behind an
index. Rituals are `.claude/commands/`; enforcement is `.claude/hooks/`.

## Consequences

- Works identically on web, desktop, CLI, and mobile. Moving machines is
  `git clone` — there is no backup system to build or maintain.
- Everything Claude "knows" is readable, diffable, and correctable by me.
- **The cost is a habit.** `/wrap` has to actually get run at the end of a
  session. If it doesn't, the repo silently goes stale and becomes worse than
  nothing, because it will confidently state things that are no longer true.
- Context budget is finite: every file imported with `@` in `CLAUDE.md` loads
  in full, every session. Growth has to be actively pruned.

## Open items

None. Revisit if Claude Code ships cross-session memory that syncs to cloud
environments — that would change the tradeoff but not eliminate the value of
curated decision records over raw transcripts.
