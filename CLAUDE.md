# Personal projects

A working repo for personal life-improvement projects. Each project lives in
its own folder under `projects/`. The point of this repo is that a new Claude
session can pick up where the last one left off without me re-explaining.

## Start here

- Current state: @PROJECT_STATE.md
- Past decisions: @docs/decisions/INDEX.md — read the index. Open a specific
  record only when it's relevant to what we're doing.
- Open questions: read `docs/working/open-questions.md` when the task touches
  something unresolved.
- How this repo works: `docs/claude-code-project-brain.md`

## Rules

- **Don't invent details about my life.** If you need a fact I haven't given
  you — a date, a number, a preference, what I did last week — ask. Filling
  it in with something plausible makes the whole repo untrustworthy.
- **Distinguish what I decided from what you suggested.** Only things I
  actually agreed to go into `PROJECT_STATE.md` or a decision record.
- **Be direct about tradeoffs.** These are habits and commitments, not code.
  If a plan looks unrealistic given what's already in progress, say so before
  we build on it.
- **Decisions with real alternatives get a record.** Run `/decide`.
- **Logs are append-only.** Never rewrite a past entry to make history tidier.
- If a doc contradicts what I say in conversation, tell me rather than
  silently picking one.

## Workflow

- `/start` — fuller onboarding when returning after a gap
- `/wrap` — before ending a session. This is what keeps the repo useful.
- `/decide <title>` — record a decision

## Conventions

- Dates are `YYYY-MM-DD`.
- Project folders are kebab-case: `projects/sleep-schedule/`.
- Keep `PROJECT_STATE.md` under 60 lines. Delete stale entries; don't append
  forever.
